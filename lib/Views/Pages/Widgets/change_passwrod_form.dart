import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Widgets/custom_button.dart';
import '../../../Widgets/custom_text_from.dart';
import '../../../cubit/chage_passwrod/chage_password_cubit.dart';
import '../../../helper/my_snackbar.dart';
//this
class ChangePasswrodForm extends StatefulWidget {
  const ChangePasswrodForm({super.key});

  @override
  State<ChangePasswrodForm> createState() => _ChangePasswrodFormState();
}

class _ChangePasswrodFormState extends State<ChangePasswrodForm> {

   final formKey = GlobalKey<FormState>();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool obscureNewPassword = true;
  bool obscureOldPassword = true;
  bool obscureConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 25,
            spreadRadius: 5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: BlocConsumer<ChagePasswordCubit, ChagePasswordState>(
        listener: (context, state) {
          if(state is ChagePasswordConfirmPassword)
          {
            Mysnackbar().showSnackbarError(title: "خطأ", context: context, message: 'كلمة السر غير متطابقة', contentType: ContentType.failure);
          }
          else if(state is ChagePasswordFauiler)
          {
            Mysnackbar().showSnackbarError(title: "خطأ", context: context, message: state.err, contentType: ContentType.failure);
          }
          else if(state is ChagePasswordSuccess)
          {
            Mysnackbar().showSnackbarError(title: "تم بنجاح", context: context, message:'تم تغيير كلمة السر بنجاح', contentType: ContentType.success);
          }else if(state is ChagePasswordwrongPasswrod)
          {
            Mysnackbar().showSnackbarError(title: "خطأ", context: context, message: 'كلمة السر القديمة غير صحيحة', contentType: ContentType.failure);
          }
          
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                Customtextfrom(
                  obscureText: obscureOldPassword,
                  onPressed: () {
                    obscureOldPassword = !obscureOldPassword;
                    setState(() {});
                  },
                  label: "كلمة المرور القديمة",
                  icon: const Icon(Icons.lock_outline),
                  textEditingController: oldPassword,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                Customtextfrom(
                  obscureText: obscureNewPassword,
                  onPressed: () {
                    obscureNewPassword = !obscureNewPassword;
                    setState(() {});
                  },
                  label: "كلمة المرور الجديدة",
                  icon: const Icon(Icons.lock_outline),
                  textEditingController: newPassword,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                Customtextfrom(
                  obscureText: obscureConfirmPassword,
                  onPressed: () {
                    obscureConfirmPassword = !obscureConfirmPassword;
                    setState(() {});
                  },
                  label: "تاكيد كلمة السر",
                  icon: const Icon(Icons.lock_outline),
                  textEditingController: confirmPassword,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                Custombutton(
                  
                    isLoading: state is ChagePasswordLoading ?true:false,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<ChagePasswordCubit>(context)
                            .changePaaswordCubit(
                                oldPassword: oldPassword.text,
                                newPasswrod: newPassword.text,
                                confirmPassword: confirmPassword.text);
                      }
                    if(state is ChagePasswordSuccess)
                    {
                        oldPassword.clear();
                      newPassword.clear();
                      confirmPassword.clear();
                    }
                    },
                    lable: 'تحديث كلمة المرور'),
              ],
            ),
          );
        },
      ),
    );
 
  }
}