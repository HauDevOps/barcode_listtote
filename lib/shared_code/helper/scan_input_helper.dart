
import 'package:layout/shared_code/enums/scan_step_enum.dart';

class ScanInputHelpers {
  static String getPlaceholderByScanStep(ScanStepEnum step) {
    switch (step) {
      case ScanStepEnum.Tote:
        return 'Scan TBVC';
      case ScanStepEnum.SKU:
      case ScanStepEnum.SkuOrSerial:
        return 'Scan Barcode / Serial';
      case ScanStepEnum.Bin:
        return 'Scan Bin';
      case ScanStepEnum.CloseTote:
        return 'Scan tote code to close';
      case ScanStepEnum.SerialSkuBin:
        return 'Scan Serial / Barcode / Bin';
      case ScanStepEnum.SkuBin:
        return 'Scan SKU/bin';
      case ScanStepEnum.TransformRequestCode:
        return 'Scan transform request';
      case ScanStepEnum.Transport:
        return 'Scan transport code';
      case ScanStepEnum.BinOrTransportOrSkuSerial:
        return 'Scan Transport / Bin / Barcode';
      case ScanStepEnum.NumberOfItem:
        return 'Input number of Item';
      case ScanStepEnum.NumberOfCase:
        return 'Input number of Case';
      case ScanStepEnum.Serial:
        return 'Scan Serial';
      case ScanStepEnum.SerialSkuCaseSticker:
        return 'Scan Serial / Barcode / Case sticker';
      case ScanStepEnum.SerialSkuCaseStickerTransport:
        return 'Scan Serial / Barcode/ Case sticker / Transport';
      case ScanStepEnum.BinOrTransport:
        return 'Scan Bin / Transport';
      case ScanStepEnum.Package:
        return 'Scan Package';
      case ScanStepEnum.ReturnPackage:
        return 'Scan returned package';
      case ScanStepEnum.ReturnSku:
        return 'Scan returned sku';
      case ScanStepEnum.StorageEquipment:
        return 'Scan PTLT';
      default:
        return '';
    }
  }
}
