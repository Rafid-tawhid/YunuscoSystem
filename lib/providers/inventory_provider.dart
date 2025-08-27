import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/production_strength_model.dart';
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


  List<ProductionStrengthModel> _productionStrengthList=[];
  List<ProductionStrengthModel> get productionStrengthList =>_productionStrengthList;


  Future<bool> getProductionStrengthInfo(DateTime dateTime) async {

    final formattedDate=DashboardHelpers.convertDateTime2(dateTime);
    var data=await apiService.getData('api/Dashboard/ProductionStregnth?date=$formattedDate');
    if(data!=null){
      _productionStrengthList.clear();
      for(var i in data['returnvalue']){
        _productionStrengthList.add(ProductionStrengthModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_productionStrengthList ${_productionStrengthList.length}');
      return true;
    }
    else {
      return false;
    }
  }
}