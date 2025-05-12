import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/chage_passwrod/chage_password_cubit.dart';
import '../../helper/constans.dart';
import 'Widgets/change_passwrod_form.dart';
import 'Widgets/header_of_change_passwrod.dart';

//this
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {


  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
            create: (context) => ChagePasswordCubit(),
            child: Scaffold(
            
              body: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kColorPrimer, kColorThreed],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child:   SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [

                       Row(
                       
                        mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           IconButton(onPressed: (){
                                             Navigator.pop(context);
                                           }, icon:const  Directionality( 
                                             textDirection: TextDirection.ltr,
                                             
                                              child: Icon(Icons.arrow_back,color: Colors.white,))),
                         ],
                       ),
                      
                     const  SizedBox(height: 60),
                  const    HeaderOfChangePasswrod(),
                    const   SizedBox(height: 40),
                    const   ChangePasswrodForm(),
                    ],
                  ),
                ),
              ),
            )));
  }


}