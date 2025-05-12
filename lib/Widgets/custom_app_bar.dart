import 'package:flutter/material.dart';

import '../helper/constans.dart';

//this
 class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize =>const  Size.fromHeight(kToolbarHeight);

   const  CustomAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
     
      title: Text(title,style:const TextStyle(color: Colors.white,fontSize: 25),),
      centerTitle: true,
      flexibleSpace: Container(
        decoration:const BoxDecoration(
          gradient: LinearGradient(
            colors: [kColorPrimer, kColorSecond],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
     
     
    );
  }


}