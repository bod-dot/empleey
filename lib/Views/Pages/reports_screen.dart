// ملف reports_screen.dart
import 'package:flutter/material.dart';



import '../../Widgets/search_customer.dart';
import '../../helper/constans.dart';
import 'Widgets/data_table_report.dart';

//this
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        leading: IconButton(onPressed: (){

          Navigator.pop(context);
        }, icon:const  Icon(Icons.arrow_back,color: Colors.white,)),
        actions: [
     IconButton(onPressed: (){
      showSearch(context: context, delegate: SearchCustomer());
     }, icon:const  Icon(Icons.search,color: Colors.white,))
        ],
      title: const Text('نظام التقارير',style: TextStyle(color: Colors.white,fontSize: 25),),
      backgroundColor: kColorPrimer,
      centerTitle: true,
      elevation: 4,
      shadowColor: kColorPrimer.withOpacity(0.3),
    ),
      body:const  DataTableReport(),
    
    );
  }
}



