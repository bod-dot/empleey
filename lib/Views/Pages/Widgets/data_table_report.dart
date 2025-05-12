import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../cubit/home_cubit/home_cubit.dart';
import '../../../helper/constans.dart';
import '../../../helper/my_snackbar.dart';
import '../../../models/customer.dart';
import '../take_reading_screen.dart';

//this
class DataTableReport extends StatefulWidget {
  const DataTableReport({super.key,  this.customer});
  final List<Customer>?customer;

  @override
  State<DataTableReport> createState() => _DataTableReportState();
}

class _DataTableReportState extends State<DataTableReport> {
 late List<Customer>customer;
 String startDate='';
 String endDate='';

 @override
  void initState() {
       getDate();

      if(widget.customer!=null)
      {
        customer=widget.customer!;
      }
      else {
        customer=BlocProvider.of<HomeCubit>(context).customers..sort((a, b) {
      if (a.electronicMeterHasBeenRead && !b.electronicMeterHasBeenRead) {
        return 1; // a قبل b
      } else if (!a.electronicMeterHasBeenRead && b.electronicMeterHasBeenRead) {
        return -1;  // a بعد b
      }
      return 0; // إذا كانتا متساويتين
    });
      }
    super.initState();
 
  }
  void getDate()
 async {
  SharedPreferences shared = await SharedPreferences.getInstance();
  startDate = shared.getString('startDatePermissions')!;
  endDate = shared.getString('endtDatePermissions')!;
  setState(() {
    
  });
   
    
  }
  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    double width =MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
             const  SizedBox(height: 20,),
           RichText(
  textAlign: TextAlign.center,
  text: TextSpan(
    style: const TextStyle(
      fontSize: 17,
      color: Colors.black87,
    ),
    children: [
      const TextSpan(text: 'تقرير قراءة عدادات الكهرباء خلال فترة التحصيل من تاريخ '),
      TextSpan(
        text: startDate,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: kColorPrimer,
        ),
      ),
      const TextSpan(text: ' إلى '),
      TextSpan(
        text: endDate,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: kColorPrimer,
        ),
      ),
    ],
  ),
),


           Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 6,
        offset:const Offset(0, 3),
      ),
    ],
  ),
  child: Expanded(
    child: DataTable(
      border: TableBorder(
        horizontalInside: BorderSide(width: 1, color: Colors.grey.shade300),
        top:const BorderSide(width: 1.5, color: Colors.black),
        bottom:const BorderSide(width: 1.5, color: Colors.black),
        verticalInside: BorderSide(width: 1, color: Colors.grey.shade300),
      ),
      columnSpacing: 15,
      headingRowColor: WidgetStateProperty.resolveWith(
        (states) => Colors.blueGrey.shade100,
      ),
      columns: const [
        DataColumn(
          label: Text(
            "الاسم",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kColorPrimer,
            ),
          ),
        ),
           DataColumn(
          label: Text(
            "رقم عداد الكهرباء",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kColorPrimer,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "رقم المشترك",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kColorPrimer,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "آخر تاريخ للسداد",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kColorPrimer,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "المتأخرة",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kColorPrimer,
            ),
          ),
        ),
      ],
      rows: customer.map((data) {
        final isRead = data.electronicMeterHasBeenRead;
        return DataRow(
          // نفعّل onSelectChanged فقط إذا isRead == true
          onSelectChanged: 
              (selected) {
                  if (isRead == true) {
                   Mysnackbar().showSnackbarError(
                    title: "ملاحظة  ",
                    context: context,
                    message: "     لقد تم قراه هذا العداد",
                    contentType: ContentType.warning);
                  }
                  else {
                  
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>TakeReadingScreen(qrCode: data.electronicMeterID.toString(),customers: data,)));
                                
                  }
                }
             ,
          color: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              return isRead
                  ? Colors.green.shade50
                  : Colors.red.shade50;
            },
          ),
          selected: isRead,
          cells: [
            DataCell(
              Row(
                children: [
                  Icon(
                    // أيقونة مختلفة حسب الحالة
                    isRead
                        ? Icons.check_circle   // ✓ قراءة كاملة
                        : Icons.hourglass_empty, // ⌛ انتظار القراءة
                    color: isRead ? Colors.green : Colors.orange,
                  ),
                 const SizedBox(width: 8),
                  Text(
                    data.customerName.toString(),
                    style:const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
             DataCell(
              Text(
                data.electronicMeterID.toString(),
                style:const TextStyle(fontSize: 18),
              ),
            ),
            DataCell(
              Text(
                data.customerID.toString(),
                style:const TextStyle(fontSize: 18),
              ),
            ),
            DataCell(
              Text(
                data.customerMovementDate != null
                    ? "${data.customerMovementDate!.year}-${data.customerMovementDate!.month.toString().padLeft(2,'0')}-${data.customerMovementDate!.day.toString().padLeft(2,'0')}"
                    : '',
                style:const TextStyle(fontSize: 18),
              ),
            ),
            DataCell(
              Text(
                '${data.customerTotalDues} ريال',
                style:const TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      }).toList(),
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}