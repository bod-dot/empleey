class Area
{
  final int areaID;
  final String areaName;

  Area({required this.areaID, required this.areaName});
  factory Area.factory({required Map<String,dynamic>jsonData})
{
  return Area(areaID: jsonData['AreaID'], areaName: jsonData['AreaName']);
}

  
  
}