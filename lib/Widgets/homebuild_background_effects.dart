import 'package:flutter/material.dart';


import '../helper/constans.dart';
//this
class Homebuildbackgroundeffects extends StatelessWidget {
  const Homebuildbackgroundeffects({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [kColorThreed.withOpacity(0.2), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          right: -150,
          child: Transform.rotate(
            angle: 0.5,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kColorSecond.withOpacity(0.1), Colors.transparent],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}