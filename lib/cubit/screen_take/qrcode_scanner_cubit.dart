

import 'package:bloc/bloc.dart';

import '../qrcode_scanner/qrcode_scanner_cubit.dart';



class QrcodeScannerCubit extends Cubit<QrcodeScannerState> {
  QrcodeScannerCubit() : super(QrcodeScannerInitial());


  void setInitial()
  {
    emit(QrcodeScannerInitial());
  }

  void checkValue({required String ? result})
  {
      if(!isValidInteger(result))
      {
        emit(QrcodeScannerNotNumber());
      }
      else if(!isValid12Number(result))
      {
       emit(QrcodeScannerNo12Number());
      }
      else
      {
        emit(QrcodeScannerSuccessfuly());
      }


  }

  bool isValidInteger(String? code) 
  { 
     if (code == null) return false;
      return int.tryParse(code) != null;
  }

  bool isValid12Number(String? code)
  {
    return code!.length==12;
  }
}
