import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../models/inventory_stock_model.dart';

class InventoryPorvider extends ChangeNotifier{

  ApiService apiService=ApiService();


  List<InventoryStockModel> _inventoryStockList=[];
  List<InventoryStockModel> get inventoryStockList=>_inventoryStockList;

  //
  Future<bool> getInventoryStockSummery() async{
    var data=await apiService.getData('api/InventoryApi/StockSummary?storeType=4&toDate=');
    if(data!=null){
      _inventoryStockList.clear();
      for(var i in data){
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
}