import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:this_is_tayrd/Views/Pages/Widgets/my_droup_down.dart';

import '../cubit/login_cubit/login_cubit.dart';
import '../helper/constans.dart';
import '../models/ares.dart';
import 'custom_button.dart';
import 'custom_text_from.dart';

//this
class BuildLoginFormLogin extends StatefulWidget {
  const BuildLoginFormLogin({super.key});

  @override
  State<BuildLoginFormLogin> createState() => _BuildLoginFormLoginState();
}

class _BuildLoginFormLoginState extends State<BuildLoginFormLogin> {
  TextEditingController area = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController passwrod = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.always;
  bool check = true;
  List<Area> areaList = [];
  @override
  void initState() {
    super.initState();
    getArea();
  }

  void getArea() async {
    BlocProvider.of<LoginCubitCubit>(context).getAreas();
  }

  @override
  Widget build(BuildContext context) {
    areaList = BlocProvider.of<LoginCubitCubit>(context).areaList;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        autovalidateMode: autovalidateMode,
        key: formKey,
        child: Column(
          children: [
            BlocBuilder<LoginCubitCubit, LoginState>(
              builder: (context, state) {
                 if(state is LoginAreasLoading)
                {
                return const Center(child: CircularProgressIndicator());
                }
                else if(state is LoginAreasLoaded)
                {
                 areaList= BlocProvider.of<LoginCubitCubit>(context).areaList;
                 return Mydropdown(areaList: areaList);
                }
                else if(state is LoginAreasLoaded)
                {
                       return const Text('لم يتم تحميل المناطق');
                }
                else 
                {
                  return Mydropdown(areaList: areaList);
                }
                
              },
            ),
            const SizedBox(height: 20),
            Customtextfrom(
              label: "رقم الهاتف",
              icon: const Icon(Icons.phone_android, color: kColorPrimer),
              textEditingController: phoneNumber,
              textInputType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            Customtextfrom(
              isPassword: true,
              obscureText: check,
              onPressed: () {
                setState(() {
                  check = !check;
                });
              },
              label: "كلمة السر",
              icon: const Icon(
                Icons.lock_open_outlined,
                color: kColorPrimer,
              ),
              textEditingController: passwrod,
            ),
            const SizedBox(height: 30),
            BlocBuilder<LoginCubitCubit, LoginState>(
              builder: (context, state) {
                return Custombutton(
                    isLoading: state is LoginLoding,
                    lable: 'تسجيل الدخول',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<LoginCubitCubit>(context).loginCub(
                            phoneNumber: int.parse(phoneNumber.text),
                            passwrod: passwrod.text);
                      }
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
