
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../Views/Pages/Widgets/home_build_animated_client_cards.dart';
import '../Views/Pages/Widgets/homebuild_row_action_buttons.dart';
import '../cubit/home_cubit/home_cubit.dart';
import '../helper/constans.dart';
import '../models/customer.dart';
import 'custom_title_in_home_page.dart';
//this
class Homebuildmaincontent extends StatefulWidget {
   const  Homebuildmaincontent({super.key, });

     

  @override
  State<Homebuildmaincontent> createState() => _HomebuildmaincontentState();
}

class _HomebuildmaincontentState extends State<Homebuildmaincontent> {
  List<Customer> customers=[];
  List<Customer> customersNotReading=[];
  String  nameArea='';
  @override
  void initState() {
      customers=BlocProvider.of<HomeCubit>(context).customers;
     customersNotReading=customers.where((element)=>element.electronicMeterHasBeenRead==false).toList();
 
    
     getNameArea();
    super.initState();
  }
  void getNameArea()
  async{
    SharedPreferences shared = await SharedPreferences.getInstance();
    nameArea = shared.getString('areaName')!;
    setState(() {
      
    });


  }
  
  @override
  Widget build(BuildContext context) {
     double averageProgress = customersNotReading.isEmpty 
    ? 1
    :1-(customersNotReading.length/ customers.length);
   
     
    return RefreshIndicator(
      onRefresh: ()
      async{
        
       
        BlocProvider.of<HomeCubit>(context).getDataAndCheckPermission();
        
   customers=BlocProvider.of<HomeCubit>(context).customers;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const Homebuildrowactionbuttons(),
             const SizedBox(height: 20),
             
              LinearProgressIndicator(
                value: averageProgress,
                backgroundColor: kColorFoured,
                valueColor :const  AlwaysStoppedAnimation<Color>(kColorPrimer),
                minHeight: 8,
              ),
             const  SizedBox(height: 20),
     customersNotReading.isNotEmpty
    ? const Customtitleinhomepage(title: 'لم يتم تحصيلهم')
    : Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            color: const Color(0xFFF0F4F8), // لون خلفية ناعم
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                 const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                 const  Text(
                    "تم أخذ القراءة لجميع العدادات",
                    style: TextStyle(
                      color: kColorPrimer,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                 const  SizedBox(height: 12),
                   Text(
                    "خلال فترة أخذ القراءات السابقة في المنطقة $nameArea",
                    style:const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
             const  SizedBox(height: 20),
               Homebuildanimatedclientcards(customers: customersNotReading, ),
              
            ],
          ),
        ),
      ),
    );
  }
}