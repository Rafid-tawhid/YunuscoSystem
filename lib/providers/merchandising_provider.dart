import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/buyer_wise_value_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'package:yunusco_group/utils/constants.dart';

class MerchandisingProvider extends ChangeNotifier{

  ApiService apiService=ApiService();
  BuyerWiseValueModel? _buyerWiseValueModel;
  BuyerWiseValueModel? get buyerWiseValueModel=>_buyerWiseValueModel;

  Future<void> getAllMerchandisingInfo() async {
    debugPrint('This is data calling...}');
    var data= await apiService.getData2('${AppConstants.baseUrl}Merchandising/MerManagementReport/BuyerWiseValue');
    debugPrint('This is data ${data}');
    if(data!=null){
      _buyerWiseValueModel=BuyerWiseValueModel.fromJson(data['returnvalue']);
    //  debugPrint('buyerWiseValueModel ${buyerWiseValueModel!.toJson()}');
    }

    notifyListeners();
  }


  List<Map<String,dynamic>> _allBuyerOrderList=[];
  List<Map<String,dynamic>> get allBuyerOrderList=>_allBuyerOrderList;

  Future<bool> getAllBuyerOrders() async{
    var data=await apiService.getData('api/Merchandising/GetBuyerOrder');
    if(data!=null){
      _allBuyerOrderList.clear();
      for(var i in data['returnvalue']){
        _allBuyerOrderList.add(i);
      }
      notifyListeners();
      debugPrint('_allBuyerOrderList ${_allBuyerOrderList.length}');
      return true;
    }
    else {
      return false;
    }

  }
}