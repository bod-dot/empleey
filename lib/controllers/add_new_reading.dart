import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import '../helper/api_my.dart';

class AddNewReading


{
  Future<bool> addNewReadingMeth({required String previousReading,required String currentReading,required String totalDuesInThisReading,required File readingImage,required String electronicMeterID,}) async {
    
    SharedPreferences shared = await SharedPreferences.getInstance(); 
    int areaId = shared.getInt("areaId")!;
    String employeeID = shared.getString("EmployeeID")!;
  List<int> imageBytes = await readingImage.readAsBytes();
  String base64Image = base64Encode(imageBytes);
      

    dynamic data = await Api().post(url: 'Add_New_Reading.php', body: {
      'PreviousReading':previousReading,
      'CurrentReading':currentReading,
      'TotalDuesInThisReading':totalDuesInThisReading,
      'ReadingImage':base64Image,
      'ElectronicMeterID':electronicMeterID,
      'EmployeeID':employeeID,
      'AreaID':areaId.toString(),
    },
    headers: {
     'Content-Type': 'application/x-www-form-urlencoded',

    });
    return data['Message']=="تم التاثير في الصفوف";
  }

}