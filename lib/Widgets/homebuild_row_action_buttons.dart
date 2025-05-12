import 'package:flutter/material.dart';

import '../Views/Pages/reports_screen.dart';
import 'main_menu_item_button.dart';


class Homebuildrowactionbuttons extends StatelessWidget {
  const Homebuildrowactionbuttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Mainmenuitembutton(icon: Icons.analytics, label: "التقارير", onTap: (){
            Navigator.push(context, MaterialPageRoute(builder:
              (context) =>const  ReportsScreen()));}),
        ),
       const  SizedBox(width: 20),
        Expanded(
          child: Mainmenuitembutton(icon: Icons.assignment_add, label:  'أخذ قراءات', onTap: (){

          //  Navigator.push(context, MaterialPageRoute(builder:  (context) =>const  ()));
          }),
        ),
      ],
    );
  }
}