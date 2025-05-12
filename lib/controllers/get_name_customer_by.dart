

import 'package:shared_preferences/shared_preferences.dart';
import 'package:this_is_tayrd/helper/api_my.dart';

class ClsGetnameByElectri
{
  Future<dynamic> getnameCustomer({required String electricityMetersID ,})
 async {
  SharedPreferences shared = await SharedPreferences.getInstance();
     int areaId = shared.getInt("areaId")!;
     String employeeID = shared.getString("EmployeeID")!;
  
       print("====================================== areaid = ${ areaId}");
       print("====================================== EmployeeID = ${ employeeID}");
       print("====================================== EmployeeID = ${ electricityMetersID}");
      dynamic data = Api().post(url: "get_name_Customer_by_Electricity_Meters.php", body: {
          "Electricity_MetersID":electricityMetersID,
        'AreaID':areaId.toString(),
        'EmployeeID':employeeID,
        
      });
      return data;


  }
}