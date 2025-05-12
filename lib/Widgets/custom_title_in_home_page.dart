import 'package:flutter/material.dart';


import '../helper/constans.dart';
//this
class Customtitleinhomepage extends StatelessWidget {
  const Customtitleinhomepage({super.key,required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style:const  TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: kColorPrimer,
        ),
      ),
    );
  }
}