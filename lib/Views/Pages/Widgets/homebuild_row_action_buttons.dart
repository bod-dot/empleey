import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:this_is_tayrd/cubit/home_cubit/home_cubit.dart';
import 'package:this_is_tayrd/helper/my_snackbar.dart';

import '../../../Widgets/main_menu_item_button.dart';
import '../reports_screen.dart';
import '../take_reading_screen.dart';
//this
class Homebuildrowactionbuttons extends StatelessWidget {
  const Homebuildrowactionbuttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Mainmenuitembutton(
              icon: Icons.analytics,
              label: "التقارير",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportsScreen())
                        );
              }),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Opacity(
                opacity: state is HomeSuccessPutNoCollection ?0.5:1,
                child: Mainmenuitembutton(
                    icon: Icons.assignment_add,
                    label: 'أخذ قراءة',
                    onTap: () {
                      if(state is HomeSuccessPutNoCollection)
                      {
                        Mysnackbar().showSnackbarError(title: "ملاحظة", context: context, message: "ليس يوم التحصيل", contentType: ContentType.help);
                      }
                      else
                      {
                        
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                            
                              builder: (context) =>  TakeReadingScreen()));
                      }
                    }),
              );
            },
          ),
        ),
      ],
    );
  }
}
