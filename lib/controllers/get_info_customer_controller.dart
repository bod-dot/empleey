

import '../helper/api_my.dart';
import '../models/customer.dart';

class GetInfoCustomerController
{
  Future<List<Customer>> getInfoCustomerMeth({required int areaId})
 async {
    List <dynamic>data = await Api().post(url: "GetInfoCustomer.php", body: {
      'AreaID':"$areaId"
    });
    List<Customer> lCustomer=[];
  for(int i=1;i<data.length;i++)
    {
   lCustomer.add(Customer.factory(jsonData: data[i]));
    }
    return lCustomer;
  }
}