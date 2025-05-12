import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:this_is_tayrd/Views/Pages/about_app.dart';
import 'package:this_is_tayrd/Widgets/no_permission_screen.dart';
import 'package:this_is_tayrd/helper/my_snackbar.dart';


import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/homebuild_background_effects.dart';
import '../../Widgets/homebuild_main_content.dart';
import '../../cubit/home_cubit/home_cubit.dart';
import '../../helper/constans.dart';
import 'chage_password.dart';
import 'drawer_my.dart';
import 'reports_screen.dart';
import 'take_reading_screen.dart';
//this
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static String id = "HomePage";
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _handleDrawerItemSelected(int index) async {
    Navigator.pop(context);

    switch (index) {
      case 0:
         Navigator.push(
                          context,
                          MaterialPageRoute(
                            
                              builder: (context) =>  TakeReadingScreen()));
        break;
      case 1:
        Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportsScreen())
                        );
   
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen()));
        break;
        case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const AboutScreen()));
      
        break;
        case 4:
        
        BlocProvider.of<HomeCubit>(context).removeDataSharedPreferences(context);
        break;
    }
  }



  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getDataAndCheckPermission();
    super.initState();
  }
  

 

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if(state is HomeNotAllow)
          {
           Mysnackbar().showSnackbarError(
                  title: "تنبية ",
                  context: context,
                  message: "ليس لديك صلاحيات في هذا المنظقة",
                  contentType: ContentType.warning);
         BlocProvider.of<HomeCubit>(context).removeDataSharedPreferences(context);
          } 

        },
       
        builder: (context, state) {
          return Scaffold(
            drawer: CustomDrawer(
              onItemSelected: _handleDrawerItemSelected,
            ),
           
            appBar:AppBar(
     
      title: const  Text("الرئيسية",style: TextStyle(color: Colors.white,fontSize: 25),),
      centerTitle: true,
      flexibleSpace: Container(
        decoration:const BoxDecoration(
          gradient: LinearGradient(
            colors: [kColorPrimer, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
     
     
    ),
            body: Stack(
              children: [
                const Homebuildbackgroundeffects(),
                if(state is HomeLoading)
                const  Center(
                child: CircularProgressIndicator(),
                )
                else if(state is HomeSuccess || state is HomeSuccessPutNoCollection)
               const  Homebuildmaincontent()
              
                else if(state is HomeFauler)
                Center(child: Text(state.err),)
                else if(state is HomeNoInternet)
                NoPermissionScreen(onPressed:  (){
    BlocProvider.of<HomeCubit>(context).getDataAndCheckPermission();
  },)
               
                
              ],
            ),
          );
        },
      ),
    );
  }
}
