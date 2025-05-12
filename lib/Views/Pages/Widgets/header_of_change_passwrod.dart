import 'package:flutter/material.dart';

//this
class HeaderOfChangePasswrod extends StatelessWidget {
  const HeaderOfChangePasswrod({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Icon(
            Icons.security_rounded,
            size: 80,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, Colors.blue.shade100],
          ).createShader(bounds),
          child:const Text(
            'تغيير كلمة المرور',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white
            )

          ),
        ),
        const SizedBox(height: 10),
        Text(
          'قم بتحديث كلمة المرور لحماية حسابك',
          style:  TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}