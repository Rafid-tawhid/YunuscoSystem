import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../models/inventory_stock_model.dart';

class InventoryPorvider extends ChangeNotifier{

  ApiService apiService=ApiService();


  List<InventoryStockModel> _inventoryStockList=[];
  List<InventoryStockModel> get inventoryStockList=>_inventoryStockList;

  //
  Future<bool> getInventoryStockSummery(DateTime date,String type) async{

    debugPrint('This is type ${type}');
    final formattedDate=formatDateSlash(date);
    var data=await apiService.getData('api/Inventory/StockSummary?storeType=$type&toDate=$formattedDate');
    if(data!=null){
      _inventoryStockList.clear();
      for(var i in data['returnvalue']){
        _inventoryStockList.add(InventoryStockModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_inventoryStockList ${_inventoryStockList.length}');
      return true;
    }
    else {
      return false;
    }
  }

  String formatDateSlash(DateTime date) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$month -$day - ${date.year}';
  }
}