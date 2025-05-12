import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:this_is_tayrd/helper/constans.dart';
//this
class Api 
{
  //dynamic
  Future<dynamic> post({
  required String url,
  required dynamic body,
  dynamic headers,
}) async {
  final response = await http.post(
    Uri.parse(kUrl + url),
    body: body is Map ? body : jsonEncode(body),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      ...?headers,
    },
    encoding: Encoding.getByName('utf-8'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  } else {
    throw Exception(
        'Problem: Status Code ${response.statusCode}, Body: ${response.body}');
  }
}
   Future<dynamic> get ({required String url})
  async {

  
   http.Response response =await http.get(Uri.parse(kUrl+url) );

   if(response.statusCode==200)
     {

       return jsonDecode(response.body);

     }
   else
     {


       throw Exception("three is a brablem the status Code is ${response.statusCode} and the body is ${jsonDecode(response.body)}");
     }
  }

  Future<bool> checkInternet()
 async {
    try{

      final response = await http.get(
        Uri.parse(kUrlCheckInternet),
      );
      if(response.statusCode ==204)
      {
        return true;
      }
      else{
        return false;
      }
    }catch(e)
    {
      return false;
    }
  }
}