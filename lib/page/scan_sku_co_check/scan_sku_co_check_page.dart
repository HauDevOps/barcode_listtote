
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:layout/base/base_bloc.dart';
import 'package:layout/model/sku_model.dart';
import 'package:layout/model/status_tote.dart';
import 'package:layout/page/scan_sku_co_check/scan_sku_co_check_bloc.dart';
import 'package:layout/router/router_name.dart';
import 'package:layout/shared_code/enums/scan_step_enum.dart';
import 'package:layout/shared_code/helper/scan_input_helper.dart';
import 'package:layout/shared_code/materials/app_color.dart';
import 'package:layout/shared_code/method/screen_arguments.dart';
import 'package:layout/shared_code/method/utils.dart';
import 'package:layout/shared_code/utils/enums/bin_type_enum.dart';
import 'package:layout/shared_code/widgets/app_bar_widget.dart';

class ScanSkuOrCodePage extends StatefulWidget {
  @override
  _ScanSkuOrCodeState createState() => _ScanSkuOrCodeState();
}

class _ScanSkuOrCodeState extends State<ScanSkuOrCodePage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _scanController = TextEditingController();
  final FocusNode _focusTextNode = FocusNode();
  ScanSkuBloc bloc;
  String _mSKU;
  String _mSTOCode;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    bloc = BlocProvider.of<ScanSkuBloc>(context);
    bloc.fetchListCoCheck();
    handleStream();
  }

  void handleStream() {
    bloc.outCheckTote.listen((value) {
      _scanController.clear();
      Navigator.pushNamed(context, Route_Named_Detail_Co_Chek,
          arguments: ScreenArguments(arg1: value, arg2: _mSKU, arg3: _mSTOCode))
          .then((value) {
        bloc.fetchCoCheckLocal();
      });
    }, onError: (error) {
      Extensions.showMessage(error.toString());
      _scanController.clear();
    });

    bloc.outSubmit.listen((value) {
      Extensions.showMessage('Xác nhận thành công');
    }, onError: (error) {
      Extensions.showMessage(error);
    });
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    _scanController.clear();
    _focusNode.dispose();
    _focusTextNode.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'co_check',
          isVisibleBackButton: false,
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _scanWidget(),
            const SizedBox(height: 5),
            _stoCodeWidget(),
            const SizedBox(height: 5),
            _bodyWidget(),
            _submitWidget()
          ],
        ));
  }

  Widget _scanWidget() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<ScanType>(
          initialData: ScanType.SKU,
          stream: bloc.outScanType,
          builder: (context, snapshot) {
            return RawKeyboardListener(
              focusNode: _focusNode,
              child: Material(
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.29),
                child: TextFormField(
                  focusNode: _focusTextNode,
                  autofocus: true,
                  textCapitalization: TextCapitalization.characters,
                  controller: _scanController,
                  onFieldSubmitted: (code) {
                    bloc.checkBarCode(code, snapshot.data);
                    FocusScope.of(context).requestFocus(_focusTextNode);
                    _scanController.clear();
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: (snapshot.data == ScanType.SKU)
                        ? ScanInputHelpers.getPlaceholderByScanStep(
                        ScanStepEnum.SkuOrSerial)
                        : ScanInputHelpers.getPlaceholderByScanStep(
                        ScanStepEnum.Tote),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.orange,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  onChanged: (value){
                    _scanController.value = TextEditingValue(
                        text: value.toUpperCase(),
                        selection: _scanController.selection);
                  },
                ),
              ),
            );
          }),
    );
  }

  Widget _stoCodeWidget(){
    return StreamBuilder(
        stream: bloc.outSTOCode,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            return Container(
              width: 0,
              height: 0,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: 0,
              height: 0,
            );
          }
          _mSTOCode = snapshot.data;
          return Text(snapshot.data,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 23));
        });
  }

  Widget _bodyWidget(){
    return Expanded(
      child: StreamBuilder(
          stream: bloc.outInfoSKU,
          builder: (context, AsyncSnapshot<SKU> snapshot) {
            if (snapshot.hasError) {
              Extensions.showMessage(snapshot.error);
              return Container(
                width: 0,
                height: 0,
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: 0,
                height: 0,
              );
            }
            _mSKU = snapshot.data.sku;
            return (snapshot.data.sku != null)
                ? Padding(
              padding: const EdgeInsets.all(5),
              child: Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                      color: Colors.black),
                ),
                elevation: 3,
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Text(
                          'SKU : ${snapshot.data.sku}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'SL : ${snapshot.data.pickedTotalQty}/${snapshot.data.totalQty}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30),
                        ),
                        const SizedBox(height: 10),
                        // Text(
                        //   'SL : ${snapshot.data.pickedTotalQty}',
                        //   style: TextStyle(
                        //       color: AppColor
                        //           .itemListViewContentTextColor,
                        //       fontSize: 30),
                        // ),
                        const SizedBox(height: 10),
                        Expanded(
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                MediaQuery.of(context)
                                    .size
                                    .width /
                                    (MediaQuery.of(context)
                                        .size
                                        .height /
                                        5),
                              ),
                              itemCount:
                              snapshot.data.listTote.length,
                              itemBuilder: (context, index) {
                                // return _gridViewBuilder(
                                //     snapshot.data.listTote[index]);
                              },
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )
                : Container();
          }),
    );
  }

  Widget _gridViewBuilder(StatusTote data) {
    return Card(
      color: AppColor.itemCardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
            color: data.status
                ? AppColor.itemListViewContentTextColor
                : AppColor.itemListViewTitleTextColor),
      ),
      elevation: 3,
      child: Container(
        height: 30,
        child: Center(
          child: Text(data.tote,
              style: TextStyle(
                  color: AppColor.itemListViewContentTextColor, fontSize: 20)),
        ),
      ),
    );
  }

  Widget _submitWidget() {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: AppColor.itemListViewTitleTextColor,
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        onPressed: () {
          bloc.submitCoCheck();
        },
        child: const Text('Xác nhận'),
      ),
    );
  }
}
