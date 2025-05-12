

import 'package:shared_preferences/shared_preferences.dart';
import 'package:this_is_tayrd/helper/api_my.dart';

class CheckPermissions
{
Future<List<int>> checkPermissionsMeth({required int areaId,required String employeeID })
async {

     dynamic data = await Api().post(url: "Check_Permissions.php", body: {

      "AreaID":'$areaId',
    "EmployeeID":employeeID
     });
    List<int>result=[];
    result.add(data['PermissionStatus']);
    result.add(data['isDataofCollection']);
      if(data['StartOfCollectionDate']?['date'] != null){
     String start=data['StartOfCollectionDate']['date'];
     String end=data['EndOfCollectionDate']['date'];
    
   
     SharedPreferences shared = await SharedPreferences.getInstance();
     shared.setString('startDatePermissions', start.substring(0,10));
     shared.setString('endtDatePermissions', end.substring(0,10));
      
  
      }


     return result;

}
}