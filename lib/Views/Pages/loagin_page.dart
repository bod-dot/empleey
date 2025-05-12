import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:this_is_tayrd/Widgets/no_permission_screen.dart';

import '../../Widgets/build_header_login.dart';
import '../../Widgets/build_login_form_login.dart';
import '../../cubit/login_cubit/login_cubit.dart';
import '../../helper/my_snackbar.dart';
import 'home_page.dart';

//this
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LognPage';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => LoginCubitCubit(),
        child: BlocConsumer<LoginCubitCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacementNamed(context, MainScreen.id);
            }
            
            else if(state is LoginNotActive)
            {
                   Mysnackbar().showSnackbarError(
                  title: "خطاء ",
                  context: context,
                  message: " حسابك غير نشط",
                  contentType: ContentType.failure);
            }
             else if (state is LoginFauild) {
              Mysnackbar().showSnackbarError(
                  title: "error",
                  context: context,
                  message: state.error,
                  contentType: ContentType.failure);
            } else if (state is LoginWrongPasswrodOrPhone) {
              Mysnackbar().showSnackbarError(
                  title: "خطاء ",
                  context: context,
                  message: "   رقم الهاتف او كلمة السر خطاء ",
                  contentType: ContentType.failure);
            }
           else if(state is LoginNoPermissoion)
            {
              Mysnackbar().showSnackbarError(
                  title: "تنبية ",
                  context: context,
                  message: "ليس لديك صلاحيات في هذا المنطقة",
                  contentType: ContentType.warning);
              
            } else if(state is LoginNoInternet)
            {
               Mysnackbar().showSnackbarError(
                  title: "تنبية ",
                  context: context,
                  message: "لا يوجد الانترنت",
                  contentType: ContentType.warning);
            }

          },
          builder: (context, state) {
            
            return Scaffold(
              body: state is LoginNoInternet? Center(
                child: 
                         NoPermissionScreen(onPressed: (){
                          BlocProvider.of<LoginCubitCubit>(context).checkInternert();
            
                         }),
              ): Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                )),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 500),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          const Buildheader(),
                          const SizedBox(height: 40),
                          const BuildLoginFormLogin(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
