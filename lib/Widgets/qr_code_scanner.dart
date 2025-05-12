import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:this_is_tayrd/Widgets/qrcode_body.dart';
import 'package:this_is_tayrd/cubit/qrcode_scanner/qrcode_scanner_cubit.dart';
import 'package:this_is_tayrd/helper/constans.dart';

class QrCodeScanner extends StatefulWidget {
  static String qrcodeScreenId='qrcode';
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
        appBar: AppBar(
          title: const Text('QR مسح رمز الـ ',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: kColorPrimer,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body:  BlocProvider(
          create: (context) => QrcodeScannerCubit(),
          child:const QrcodeBody(),
        ));
  }
}
