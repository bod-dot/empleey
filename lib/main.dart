import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:this_is_tayrd/cubit/simple_observer.dart';
import 'package:this_is_tayrd/cubit/take_reading/take_reading_cubit.dart';
import 'Views/Pages/home_page.dart';
import 'Views/Pages/loagin_page.dart';
import 'Widgets/qr_code_scanner.dart';
import 'cubit/home_cubit/home_cubit.dart';
import 'helper/constans.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 

String? employeeID;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences shared = await SharedPreferences.getInstance();
  employeeID = shared.getString("EmployeeID");
  Bloc.observer=SimpleObserver();

    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
            BlocProvider(
          create: (context) => HomeCubit(),
          
        ),
            BlocProvider(
                create:(context)=>TakeReadingCubit(),
    
            ),
        ],
              child: MaterialApp(
            routes: {
              LoginScreen.id: (context) => const LoginScreen(),
              MainScreen.id: (context) => const MainScreen(),
             QrCodeScanner.qrcodeScreenId:(context)=>const QrCodeScanner()
            //  TakeReadingScreen.id:(context)=>const TakeReadingScreen()
            },
            title: 'نظام إدارة العملاء',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: kColorPrimer,
              fontFamily: 'Poppins',
             
              appBarTheme: AppBarTheme(
                backgroundColor: kColorPrimer,
                elevation: 8,
                shadowColor: kColorPrimer.withOpacity(0.5),
              ),
            ),
            home: employeeID == null ? const LoginScreen() : const MainScreen(),
          ),
    );
  }
}
