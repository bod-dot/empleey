import 'package:shared_preferences/shared_preferences.dart';

import '../helper/api_my.dart';



class LoginContrloller

{

  Future<int> loginMeth({required int phoneNumber,required String passwrod})
 async {
  Map<String,dynamic> data= await Api().post(url: "LoginColl.php", body: {
   
    'PhoneNumber':'$phoneNumber',
    "password":passwrod
  });
  bool isLogin=data['message']=='No data found';
  if(!isLogin)
  {
    if(data['EmployeeState']==0)
    {
        return 2;
    }

    SharedPreferences shared = await SharedPreferences.getInstance();
    String employeeID = data['EmployeeID'].toString();
    String employeeName = data['EmployeeName'];
   
    shared.setString("EmployeeID", employeeID);
    shared.setString("EmployeeName", employeeName);
    return 1;

  }

  return 0;


  }

}