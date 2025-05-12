import 'package:flutter/material.dart';

//this
class Buildheader extends StatelessWidget {
  const Buildheader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        Text(
          'مرحباً بك!',
          style:  TextStyle(
            fontFamily: 'Poppins',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
           ) ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          textAlign: TextAlign.center,
           'سجّل الدخول لاستعراض وقراءة عدادات الكهرباء بمنطقتك',
          style:  TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}