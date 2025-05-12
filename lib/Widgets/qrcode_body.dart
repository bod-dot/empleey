import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:this_is_tayrd/Widgets/qrcode_initial.dart';
import 'package:this_is_tayrd/Widgets/qrcode_successful.dart';
import 'package:this_is_tayrd/cubit/qrcode_scanner/qrcode_scanner_cubit.dart';

import '../helper/constans.dart';
import 'custom_button.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrcodeBody extends StatefulWidget {
  const QrcodeBody({super.key});

  @override
  State<QrcodeBody> createState() => _QrcodeBodyState();
}

class _QrcodeBodyState extends State<QrcodeBody> with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera().then((_) {
        controller?.resumeCamera();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return BlocBuilder<QrcodeScannerCubit, QrcodeScannerState>(
      builder: (context, state) {
        return Column(
          children:[
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: kColorPrimer.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: kColorPrimer,
                      borderRadius: 8,
                      borderLength: 25,
                      borderWidth: 6,
                      cutOutSize: MediaQuery.of(context).size.width * 0.75,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:Column(children: [

                      if(state is QrcodeScannerInitial)
                      const QrcodeInitial()
                   else if(state is QrcodeScannerSuccessfuly)
                   QrcodeSuccessful(result: result!.code!)
                   
               
                      
                      else if(state is QrcodeScannerNo12Number || state is QrcodeScannerNotNumber)
                      Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'رمز غير صحيح!',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          state is QrcodeScannerNotNumber?
                                          'يجب أن يحتوي الرمز على أرقام فقط':
                                          'يجب ان يكون 12 رقم فقط',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Custombutton(
                                      onPressed: () {
                                        setState(() {
                                          result = null;
                                        });
                                        BlocProvider.of<QrcodeScannerCubit>(context).setInitial();
                                        controller?.resumeCamera();
                                      },
                                      lable: "إعادة المحاولة",
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              )
                      
                    ],)
                       ),
              ),
            )
          ],
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && result == null) {
        setState(() {
          result = scanData;
        });
        BlocProvider.of<QrcodeScannerCubit>(context).checkValue(result: result?.code);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }
}
