import 'package:layout/base/base_bloc.dart';
import 'package:layout/model/co_check.dart';
import 'package:layout/remote/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BaseBloc {
  final _toteListController = BehaviorSubject<CoCheck>();

  Stream<CoCheck> get toteListStream => _toteListController.stream;

  Future getListTote() async {
    new Repository().fetchCoCheck().then((value) {
      _toteListController.sink.add(value);
    }).catchError((error) {
      print('Debug erorr ${error}');
      _toteListController.sink.addError(error);
    });
  }
  //
  // Future checkValidBarcode(postData) async {
  //   String code = postData.Code;
  //   String plu = '';
  //   var prefixCode = code.substring(0, 2);
  //   if (prefixCode == '26') {
  //     plu = code.substring(0, 8);
  //   } else if (prefixCode == '89') {
  //     plu = code.substring(0, 13);
  //   }
  // }

  @override
  void dispose() {
    _toteListController.close();
    // TODO: implement dispose
  }
}
