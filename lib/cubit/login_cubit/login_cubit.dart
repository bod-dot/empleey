import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:this_is_tayrd/helper/api_my.dart';
import '../../controllers/area_controller.dart';
import '../../controllers/check_permissions_controller.dart';
import '../../controllers/login_controller.dart';
import '../../helper/constans.dart';
import '../../models/ares.dart';


part 'login_state.dart';

class LoginCubitCubit extends Cubit<LoginState> {
  LoginCubitCubit() : super(LoginInitial());
  int areaId =0;
 late  String areaName ;
  List<Area> areaList=[];

void loginCub({required int phoneNumber,required String passwrod})
  async{
  emit(LoginLoding());
  bool check=await Api().checkInternet();
   if(check){
  try{
    
    int isLogin=  await LoginContrloller().loginMeth(phoneNumber: phoneNumber, passwrod: passwrod);
    if(isLogin==1)
    {
     checkPermissionsCubit();

    }
    else if(isLogin==2)
    {
      emit(LoginNotActive());
    }
    else 
    {
      emit(LoginWrongPasswrodOrPhone());
    }
 

  }catch(e)
  {
    
    emit(LoginFauild(error: e.toString()));
  }
   }
   else
   {
  emit(LoginNoInternet());
   }
}
  
Future<bool> checkInternert()
async{
   try
   {
     final response = await http.get(
      Uri.parse(kUrlCheckInternet), 
    );

    if(response.statusCode==204)
    {
      emit(LoginInitial());
     return true;
    }
    else{
        emit(LoginNoInternet());
     
      return false;
    }

  
   } catch(e)
   {
       emit(LoginNoInternet());
       return false;
   }
  


}

void checkPermissionsCubit()
async{
 
 SharedPreferences shared = await SharedPreferences.getInstance();
     String employeeID= shared.getString('EmployeeID')!;
      shared.setInt("areaId", areaId);
      List<int> data=await CheckPermissions().checkPermissionsMeth(areaId: areaId, employeeID: employeeID);
int checkPermissions=data.first;
       if(checkPermissions==1)
       {
         areaName= areaList.firstWhere((area)=> area.areaID ==areaId).areaName;
         shared.setString('areaName',areaName);
     emit(LoginSuccess());
       }
       else
       {
        emit(LoginNoPermissoion());
       }
}

void getAreas()
async{
  emit(LoginAreasLoading());
  areaList =await AreaController().getArea();
  if(areaList.isEmpty)
  {
    emit(LoginNoInternet());
  }else 
  {
    areaId=1;
    emit(LoginAreasLoaded());
  }

}




}

