import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:this_is_tayrd/Widgets/camer_api.dart';
import 'package:this_is_tayrd/Widgets/qr_code_scanner.dart';
import 'package:camera/camera.dart';
import 'package:this_is_tayrd/cubit/home_cubit/home_cubit.dart';
import 'package:this_is_tayrd/cubit/take_reading/take_reading_cubit.dart';
import '../../Widgets/cusotm_text_form_in_tack_new_reanding.dart';
import '../../Widgets/custom_button.dart';
import '../../helper/constans.dart';
import '../../helper/my_snackbar.dart';
import '../../models/customer.dart';

//this

class TakeReadingScreen extends StatefulWidget {
   TakeReadingScreen({
    super.key, this.qrCode,     this.customers,
  });
  final String? qrCode ;
   Customer? customers;

  static String id = 'ReadingScreen';

  @override
  State<TakeReadingScreen> createState() => _TakeReadingScreenState();
}

class _TakeReadingScreenState extends State<TakeReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController qrCode = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController reading = TextEditingController();
  @override
  void initState() {
 if (widget.qrCode?.isNotEmpty ?? false)
    {
       qrCode.text=widget.qrCode!;
         name.text=widget.customers!.customerName;
    }

    BlocProvider.of<TakeReadingCubit>(context).setTakeReadingInitial();
    super.initState();
  }


   Future<void> _navigateToCameraScreen() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        Mysnackbar().showSnackbarError(
          title: "خطأ",
          context: context,
          message: "لا توجد كاميرا متاحة",
          contentType: ContentType.failure,
        );
        return;
      }
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvancedMeterReader(qrCode: qrCode.text),
        ),
      );
    } catch (e) {
      Mysnackbar().showSnackbarError(
        title: "خطأ",
        context: context,
        message: "فشل في فتح الكاميرا: ${e.toString()}",
        contentType: ContentType.failure,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TakeReadingCubit, TakeReadingState>(
      listener: (context, state) {
     if(state is TakeReadingAfterQrcode)
     { 
      
      qrCode.text=BlocProvider.of<TakeReadingCubit>(context).qrCode!;
      BlocProvider.of<TakeReadingCubit>(context).checkElectricity(electricityMetersID: qrCode.text);
     
     }
       if (state is TakeReadingNoDataFound)
       {
           Mysnackbar().showSnackbarError(
                  title: "خطاء ",
                  context: context,
                  message: "  خطاء في رقم عداد الكهرباء ",
                  contentType: ContentType.failure);
                  name.clear();
       }
        else if (state is TakeReadingNoPermission)
       {
           Mysnackbar().showSnackbarError(
                  title: " ملاحظة ",
                  context: context,
                  message: "  هذا العداد ليس ضمن منطقتك ",
                  contentType: ContentType.warning);
                   name.clear();
       }

          else if (state is TakeReadingHasBeenRead)
       {
           Mysnackbar().showSnackbarError(
                  title: " ملاحظة ",
                  context: context,
                  message: " لقد تم قراءة هذا العداد مسبقا",
                  contentType: ContentType.warning);
                   name.clear();
                
       }
          else if (state is TakeReadingSuccessfully)
       {
         name.text=state.customerName;
         widget.customers=BlocProvider.of<HomeCubit>(context).customers.where((element) => element.electronicMeterID==int.parse(qrCode.text)).first;  
       }
            else if (state is TakeReadingNoInternt)
       {
           Mysnackbar().showSnackbarError(
                  title: " خطاء ",
                  context: context,
                  message:'لا يوجد انترنت يوجاء التاكد من الانترنت',
                  contentType: ContentType.failure);
                   name.clear();
                    
       }
            else if (state is TakeReadingerror)
       {   
           Mysnackbar().showSnackbarError(
                  title: " error ",
                  context: context,
                  message:state.erroMessage,
                  contentType: ContentType.failure);
                  // name.clear();
                   print(state.erroMessage);
                
       }
       else if(state is TakeReadinCurrent)
       {
        reading.text=BlocProvider.of<TakeReadingCubit>(context).reading!;

       }
       else if(state is TakeReadingSuccessfullyAddNewReading)
       {
        BlocProvider.of<TakeReadingCubit>(context).setTakeReadingInitial();
        qrCode.clear();
        name.clear();
        reading.clear();
        Navigator.pop(context);
        BlocProvider.of<HomeCubit>(context).getDataAndCheckPermission();
        Mysnackbar().showSnackbarError(
                  title: "نجاح ",
                  context: context,
                  message: "تم ارسال القراءة بنجاح",
                  contentType: ContentType.success);

       }
       else if(state is TakeReadinFailedAddNewReading)
       {
        BlocProvider.of<TakeReadingCubit>(context).setTakeReadingInitial();
        Navigator.pop(context);
        Mysnackbar().showSnackbarError(
                  title: "خطأ ",
                  context: context,
                  message: "فشل في ارسال القراءة",
                  contentType: ContentType.failure);
       }else if(state is TakeReadinPreviousReadingBiggeThenCurrentReading)
       {
         Mysnackbar().showSnackbarError(
                  title: "خطاء ",
                  context: context,
                  message: "  القراءة السابقة اكبر من القراءة الحالية",
                  contentType: ContentType.help);


       }
        

       
       
      },
     builder: (context, state) {
      return 
       Scaffold(
        appBar: AppBar(
          title: const Text(
            'أخذ قراءة جديدة ⚡',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: kColorPrimer, // تغيير هنا
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: AnimationLimiter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            Lottie.asset(
                              'asset/animations/electric.json',
                              width: 150,
                              repeat: true,
                            ),
                            const SizedBox(height: 30),
                            Cusotmtextformintacknewreanding(

                              onChanged: (value)
                              {
                                if(value.length==12)
                                {
                                  BlocProvider.of<TakeReadingCubit>(context).checkElectricity(electricityMetersID: qrCode.text);
                                }
                              },
                              isEnable: state is TakeReadingLoadin,
                              maxLength: 12,
                              label: 'رقم العداد',
                              icon: Icons.electric_meter_outlined,
                              text: qrCode,
                              textInputType: TextInputType.number,
                              validator: (v){
                                  if(v!.isEmpty) {
                                    return 'رقم العداد مطلوب';
                                  } else if (v.length < 12) {
                                    return 'رقم العداد غير صحيح';
                                  } else {
                                    return null;
                                  }
                              },
                              suffix: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, QrCodeScanner.qrcodeScreenId);
                                },
                                child: const Icon(
                                  Icons.qr_code,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Cusotmtextformintacknewreanding(
                              suffix:  state is TakeReadingLoadin?const SizedBox(
                                height: 10,
                                width: 10,
                                child:  CircularProgressIndicator(color: Colors.white,)):null,
                              label: 'اسم العميل',
                              icon: Icons.person_outline,
                              validator: (v) =>
                                  v!.isEmpty ? ' اسم العميل مطلوب' : null,
                              text: name,
                              isEnable: true,
                            ),
                            const SizedBox(height: 25),
                            Cusotmtextformintacknewreanding(
                              label: 'القراءة الحالية',
                              icon: Icons.speed_outlined,
                              textInputType: TextInputType.number,
                              validator: (v) =>
                                  v!.isEmpty ? 'أدخل القراءة' : null,
                              text: reading,
                              suffix: InkWell(
                                onTap: () {
                               //   Navigator.push(context, MaterialPageRoute(builder: (Context)=>AdvancedMeterReader(qrCode: int.parse(qrCode.text))));
    
                                  _navigateToCameraScreen();
                                },
                                child: const Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                ),
                              ),
                              isEnable: false,
                            ),
                            
                            const SizedBox(height: 40),
                             BlocProvider.of<TakeReadingCubit>(context).originalImageFile==null?const SizedBox():Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: FileImage(BlocProvider.of<TakeReadingCubit>(context).originalImageFile!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          
                            Custombutton(
                              isLoading: state is TakeReadingLoadingAddNewReading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                 BlocProvider.of<TakeReadingCubit>(context)
                                 .addNewReading(previousReading:'${ widget.customers!.currentReading}', currentReading: reading.text, totalDuesInThisReading: widget.customers!.customerTotalDues.toString(),  electronicMeterID: qrCode.text) ;                         

                                }
                              },
                              lable: "ارسال القراءة",
                              color: kColorSecond,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
    );
  }
}
