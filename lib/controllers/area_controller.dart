import 'dart:async';
import 'package:this_is_tayrd/helper/api_my.dart';
import 'package:this_is_tayrd/models/ares.dart';

class AreaController
{
 

Future<List<Area>> getArea()
async{
 bool check=await Api().checkInternet();
 if(check){
  List<dynamic> data =await Api().get(url: 'GetAllArea.php');
  List<Area> areaList=[];
  for(int i=0;i<data.length;i++)
  {
    areaList.add(Area.factory(jsonData: data[i]));
  }
  return areaList;
 }
 return [];
}

}