class Customer
{
  final int customerID;
  final String customerName;
  final String customerTotalDues;
  final bool electronicMeterHasBeenRead;
  final DateTime ?customerMovementDate;
  final int electronicMeterID;
  final String ? currentReading;

  Customer( {required this.customerID, required this.customerName, 
  required this.customerTotalDues, required this.electronicMeterHasBeenRead, 
  required this.customerMovementDate,required this.electronicMeterID,required this.currentReading});

  // هنا توجد مشكله خل
   factory Customer.factory({required dynamic jsonData})
{
  return Customer(
    customerID: jsonData['CustomerID']??0,
     customerName: jsonData['CustomerName']??'',
      customerTotalDues: (jsonData['CustomerTotalDues']),

   electronicMeterHasBeenRead:jsonData['ElectronicMeterHasBeenRead']==0?false:true ,
    customerMovementDate:jsonData['CustomerMovementDate'] != null
        ? DateTime.parse(jsonData['CustomerMovementDate']['date'])
        :null,electronicMeterID:  jsonData['ElectronicMeterID'],
        currentReading: (jsonData['CurrentReading'].toString()));
}
}