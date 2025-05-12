import 'package:flutter/material.dart';



import '../helper/constans.dart';
//this
class Custombutton extends StatelessWidget {
  const  Custombutton({super.key, this.isLoading=false , required this.onPressed,required this.lable,this.color});
  final bool  isLoading ;
 final VoidCallback onPressed;
  final String lable;
 final Color ?color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:  color??kColorPrimer,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                lable,
                style:const  TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}