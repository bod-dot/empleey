import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:this_is_tayrd/cubit/take_reading/take_reading_cubit.dart';

import '../helper/constans.dart';



class QrcodeSuccessful extends StatefulWidget {
  const QrcodeSuccessful({super.key, required this.result});
  final String result;

  @override
  State<QrcodeSuccessful> createState() => _QrcodeSuccessfulState();
}

class _QrcodeSuccessfulState extends State<QrcodeSuccessful> {
  @override
  void initState() {
    BlocProvider.of<TakeReadingCubit>(context).takeQrcode(result: widget.result);
  Future.delayed( const  Duration(milliseconds: 10),
 () {
       
     Navigator.pop(context);
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              const Text(
                'تم المسح بنجاح!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kColorPrimer,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'رقم العداد: ${widget.result}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        // SizedBox(
        //   width: double.infinity,
        //   child: Custombutton(
        //     onPressed: () {

        //       BlocProvider.of<TakeReadingCubit>(context).takeQrcode(result: widget.result);
        //  Navigator.pop(context);
        //     },
        //     lable: "متابعة",
        //   ),
        // )
      ],
    );
  }
}