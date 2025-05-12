// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:this_is_tayrd/helper/api_my.dart';

import '../../Views/Pages/loagin_page.dart';
import '../../controllers/check_permissions_controller.dart';
import '../../controllers/get_info_customer_controller.dart';

import '../../models/customer.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

List<Customer>customers=[];
String ? electronicMeterID;

  void getDataAndCheckPermission()
 async {
  emit(HomeLoading());

bool checkInternet=await Api().checkInternet();
      
      if(checkInternet)
      {
           checkPermissions();
      }else
     {
      emit(HomeNoInternet());
     }
  }



void checkPermissions()
async{
   SharedPreferences shared = await SharedPreferences.getInstance();
     int areaId = shared.getInt("areaId")!;
     String employeeID = shared.getString("EmployeeID")!;
try{

     List<int>data =await CheckPermissions().checkPermissionsMeth(areaId: areaId, employeeID: employeeID);
     int checkPermissions=data.first;
     if(checkPermissions==1)
     {
    customers  = await GetInfoCustomerController().getInfoCustomerMeth(areaId: areaId);

      
        checkIsCollection(data.last);

     }
     else{
      emit(HomeNotAllow());
     }
}catch (e)
{
  
emit(HomeFauler(err: e.toString()));
}

}

  void checkIsCollection(int isCollection)
  {
   
 if(isCollection==1)
 {
   emit(HomeSuccess());
   
 }
 else
 {
  
  emit(HomeSuccessPutNoCollection());
 }
  }


  void removeDataSharedPreferences(BuildContext context)
async{
SharedPreferences shared = await SharedPreferences.getInstance();
        shared.remove('EmployeeID');
        shared.remove('EmployeeName');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
}
}
