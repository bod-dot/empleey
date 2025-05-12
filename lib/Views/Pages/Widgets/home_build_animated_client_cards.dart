import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:this_is_tayrd/Views/Pages/take_reading_screen.dart';

import 'package:this_is_tayrd/models/customer.dart';




import '../../../Widgets/custometail_row.dart';
import '../../../helper/constans.dart';

//this
class Homebuildanimatedclientcards extends StatelessWidget {
  const Homebuildanimatedclientcards({super.key, required, required this.customers });
  
 
 final  List<Customer> customers;

  @override
  Widget build(BuildContext context) {

    return AnimationLimiter(
      child: SizedBox(
        height: 280,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: customers.length<6?customers.length:6,
          physics:const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item =  customers[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration:const  Duration(milliseconds: 500),
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: Container(
                    width: 300,
                    margin: const  EdgeInsets.only(right: 20),
                    padding:const  EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Colors.white, kColorFoured.withOpacity(0.3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset:const  Offset(3, 3),
                        ),
                       const  BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(-3, -3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TakeReadingScreen(qrCode:item.electronicMeterID.toString(), customers: item,)));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: kColorPrimer,
                                  child: Text(
                                    item.customerName[0],
                                    style:  const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                               const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item.customerName,
                                    style: const  TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: kColorPrimer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...buildClientDetails(item),
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