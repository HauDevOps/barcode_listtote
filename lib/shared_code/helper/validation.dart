import 'package:layout/model/check_plu.dart';
import 'package:layout/model/plu_model.dart';

class Validation {
  // static isPhoneValid(String phone) {
  //   final regexPhone = RegExp(r'^[0-9]+$');
  //   return regexPhone.hasMatch(phone);
  // }

  static bool isUserNameValid(String phone) {
    return true;
  }

  static bool isPassValid(String pass) {
    return pass.length >= 6;
  }

  static bool isDisplayNameValid(String displayName) {
    return displayName.length > 5;
  }

  static bool checkDisplaySameValid(String newPassWord, String reInputPassWord) {
    return reInputPassWord == newPassWord;
  }

  static Future checkBarCode(String barCode, List<PLUsEntity> plus) async{
    if(barCode.contains('|')){
      return CheckPLU(
          code: 0, message: 'Sai định dạng BarCode', sku: '', plu: '');
    }

    final code = barCode;
    final prefixCode = code.substring(0, 2);
    var plu = '';

    if (prefixCode == '26') {
      plu = code.substring(0, 8);
    } else if (prefixCode == '89') {
      plu = code.substring(0, 13);
    }

    final checkPLU = plus.where((element) => element.plu == plu);
    if (!checkPLU.isNotEmpty) {
      return CheckPLU(
          code: 0, message: 'Không tìm thấy BarCode', sku: '', plu: '');
    }
    return CheckPLU(
        code: 1, message: '', sku: checkPLU.first.sku, plu: checkPLU.first.plu);
  }
}
