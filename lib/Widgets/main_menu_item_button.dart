import 'package:flutter/material.dart';

import '../helper/constans.dart';
//this
class Mainmenuitembutton extends StatelessWidget {
   const  Mainmenuitembutton({super.key, required this.icon, required this.label, required this.onTap});
  final IconData icon;
      final String label;
      final VoidCallback onTap;

  @override
  
  Widget build(BuildContext context) {
    
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(-3, -3),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset:const  Offset(3, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kColorPrimer, size: 30),
           const SizedBox(height: 8),
             Text(label, style:const  TextStyle(color: kColorPrimer, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}