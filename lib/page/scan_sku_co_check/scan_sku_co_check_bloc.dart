import 'dart:convert';

import 'package:layout/base/base_bloc.dart';
import 'package:layout/model/co_check.dart';
import 'package:layout/model/sku_model.dart';
import 'package:layout/model/status_tote.dart';
import 'package:layout/model/item_model.dart';
import 'package:layout/remote/repository/repo.dart';
import 'package:layout/shared_code/helper/validation.dart';
import 'package:layout/shared_code/materials/constant.dart';
import 'package:layout/shared_code/utils/enums/bin_type_enum.dart';
import 'package:layout/shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class ScanSkuBloc extends BaseBloc {
  final _repository = Repository();
  CoCheck mCoCheck;
  String _mSKU;

  final _infoSKUController = BehaviorSubject<SKU>();

  Stream<SKU> get outInfoSKU => _infoSKUController.stream;

  final _infoToteController = BehaviorSubject<int>();

  Stream<int> get outCheckTote => _infoToteController.stream;

  final _scanTypeController = BehaviorSubject<ScanType>();

  Stream<ScanType> get outScanType => _scanTypeController.stream;

  final _submitController = BehaviorSubject<bool>();

  Stream<bool> get outSubmit => _submitController.stream;

  final _stoCodeController = BehaviorSubject<String>();

  Stream<String> get outSTOCode => _stoCodeController.stream;

  Future fetchListCoCheck() async {
    final data = await SPref.instance.get(SPrefCache.KEY_CO_CHECK);
    // if (data == null) {
    //   print('DevDebug remote data');
    //   await _repository.fetchCoCheck().then(saveData).catchError((error) {
    //     print('DevDebug ${error.toString()}');
    //     _infoSKUController.sink.addError(error.toString());
    //   });
    // } else {
    //   final mDataLocal = CoCheck.fromJson(jsonDecode(data));
    //   await _repository.fetchCoCheck().then((value) {
    //     if (mDataLocal.stoCode == value.stoCode) {
    //       print('DevDebug get Data local stoCode = stoCode local');
    //       mCoCheck = mDataLocal;
    //     } else {
    //       print('DevDebug get Data local stoCode != stoCode local');
    //       saveData(value);
    //     }
    //   }).catchError((error) {
    //     _infoSKUController.sink.addError(error.toString());
    //   });
    // }

    await _repository.fetchCoCheck().then(saveData).catchError((error) {
      print('DevDebug ${error.toString()}');
      _infoSKUController.sink.addError(error.toString());
    });
  }

  Future saveData(CoCheck coCheck) async {
    await SPref.instance.set(SPrefCache.KEY_CO_CHECK, jsonEncode(coCheck));
    mCoCheck = coCheck;
    _stoCodeController.sink.add(coCheck.stoCode);
  }

  Future checkBarCode(String barCode, ScanType scanType) async {
    if (mCoCheck != null) {
      if (scanType == ScanType.SKU) {
        final checkPLU = await Validation.checkBarCode(barCode, mCoCheck.plus);
        if (checkPLU.code == 0) {
          await _loadFile('audio_no.mp3');
          _infoSKUController.sink.addError(checkPLU.message);
        } else {
          await findSKU(checkPLU.sku);
        }
      } else {
        await findTote(barCode);
      }
    }
  }

  Future findSKU(String sku) async {
    final skuEntity = mCoCheck.sku.where((element) => element.sku == sku);

    if (skuEntity.isNotEmpty) {
      // if (skuEntity.first.pickedTotalQty == skuEntity.first.totalQty) {
      //   _infoSKUController.sink.addError('SKU đã đủ số lượng');
      // } else {
      //   final mSKU = skuEntity.first;
      //   findListTote(sku, mSKU);
      //   _infoSKUController.sink.add(mSKU);
      //   _scanTypeController.sink.add(ScanType.Tote);
      //   _mSKU = skuEntity.first.sku;
      // }
      final mSKU = skuEntity.first;
      findListTote(sku, mSKU);
      _infoSKUController.sink.add(mSKU);
      _scanTypeController.sink.add(ScanType.Tote);
      _mSKU = skuEntity.first.sku;
      await _loadFile('audio_yes.mp3');
    } else {
      await _loadFile('audio_no.mp3');
      _infoSKUController.sink.addError('Không tìm thấy SKU');
    }
  }

  SKU findListTote(String sku, SKU skuEntity) {
    final _listTote = <StatusTote>[];

    for (final item in mCoCheck.rows) {
      if (item.detail.items != null) {
        final productInfo =
            item.detail.items.where((element) => element.sku == sku);
        if (productInfo.isNotEmpty) {
          _listTote.add(StatusTote(
              tote: productInfo.first.tote,
              status: productInfo.first.pickedQty == productInfo.first.qty));
        }
      }
    }

    for (final statusTote in _listTote) {
      final sTemp = statusTote;
      if (statusTote.status) {
        _listTote.remove(statusTote);
        _listTote.add(sTemp);
      }
    }

    // skuEntity.listTote = _listTote;
    saveData(mCoCheck);
    return skuEntity;
  }

  Future findTote(String tote) async {
    final index = mCoCheck.rows.indexWhere((element) => element.tote == tote);
    if (index >= 0) {
      if (mCoCheck.rows[index].detail.items != null) {
        final item = mCoCheck.rows[index].detail.items
            .where((element) => element.sku == _mSKU);
        if (item.isNotEmpty) {
          // if (item.first.pickedQty == item.first.qty) {
          //   _infoToteController.sink.addError('Đã đủ SKU trong Tote');
          // } else {
          //   _infoToteController.sink.add(index);
          // }
          await _loadFile('audio_yes.mp3');
          _infoToteController.sink.add(index);
        } else {
          await _loadFile('audio_no.mp3');
          _infoToteController.sink.addError('Không tìm thấy Tote');
        }
      }
    } else {
      await _loadFile('audio_no.mp3');
      _infoToteController.sink.addError('Không tìm thấy Tote');
    }
  }

  Future fetchCoCheckLocal() async {
    await _repository.fetchCoCheckLocal().then((value) async {
      if (value != null) {
        final skuEntity = value.sku.where((element) => element.sku == _mSKU);
        if (skuEntity.isNotEmpty) {
          if (skuEntity.first.pickedTotalQty == skuEntity.first.totalQty) {
            _infoSKUController.sink
                .add(SKU(sku: null, pickedTotalQty: 0, totalQty: 0));
            _scanTypeController.sink.add(ScanType.SKU);
          } else {
            _infoSKUController.sink.add(skuEntity.first);
          }
        } else {
          await _loadFile('audio_no.mp3');
          _infoSKUController.sink.addError('Không tìm thấy SKU');
        }
        mCoCheck = value;
      }
    }).catchError((error) {
      print('DevDebug fetchCoCheckLocal error $error');
    });
  }

  Future submitCoCheck() async {
    final data = await SPref.instance.get(SPrefCache.KEY_CO_CHECK);
    await _repository.submitCoCheck(jsonDecode(data)).then((value) {
      if (!value.status) {
        _submitController.sink.addError(value.data);
      } else {
        _infoSKUController.sink
            .add(SKU(sku: null, pickedTotalQty: 0, totalQty: 0));
        _submitController.sink.add(true);
        SPref.instance.remove(SPrefCache.KEY_CO_CHECK);
      }
    }).catchError((error) {
      _submitController.sink.addError(error);
    });
  }

  Future _loadFile(String patch) async {
    await audioCache.play(patch);
  }

  @override
  void dispose() {
    super.dispose();
    _infoSKUController.close();
    _infoToteController.close();
    _scanTypeController.close();
    _submitController.close();
    _stoCodeController.close();
  }
}
