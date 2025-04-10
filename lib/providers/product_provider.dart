import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/models/buyer_wise_material_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';

class ProductProvider extends ChangeNotifier{
  ApiService apiService=ApiService();

  List<dynamic> _allCategoryList=[];
  List<dynamic> get allCategoryList=>_allCategoryList;

  Future<bool> getAllCategoryList() async{
    var data=await apiService.getData('api/PreSalesApi/GetStyleCategoryList');
    if(data!=null){
      _allCategoryList.clear();
      for(var i in data['returnvalue']){
        _allCategoryList.add(i);
      }
      notifyListeners();
      debugPrint('_allCategoryList ${_allCategoryList.length}');
      return true;
    }
    else {
      return false;
    }

  }

  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  setLoading(bool val){
    _isLoading=val;
    notifyListeners();
  }

  List<dynamic> _allBuyerList=[];
  List<dynamic> get allBuyerList=>_allBuyerList;

  Future<bool> getAllBuyerInfo() async{
    var data=await apiService.getData('api/PreSalesApi/AllBuyer');
    if(data!=null){
      _allBuyerList.clear();
      for(var i in data['returnvalue']){
        _allBuyerList.add(i);
      }
      notifyListeners();
      debugPrint('_allBuyerList ${_allBuyerList.length}');
      return true;
    }
    else {
      return false;
    }
  }

  bool _isSelectCat=true;
  bool get isSelectCat => _isSelectCat;
  void setSelector(bool bool) {
    _isSelectCat=bool;
    notifyListeners();
  }

  List<BuyerWiseMaterialModel> _buyerMaterialList=[];
  List<BuyerWiseMaterialModel> get buyerMaterialList=>_buyerMaterialList;

  Future<bool> getBuyerWiseMaterialList(String code) async {
    var data=await apiService.getData('api/PreSalesApi/BuyerWiseMaterialList?buyerId=$code');
    if(data!=null){
      _buyerMaterialList.clear();
      for(var i in data){
        _buyerMaterialList.add(BuyerWiseMaterialModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_buyerMaterialList ${_buyerMaterialList.length}');
      return _buyerMaterialList.isNotEmpty?true:false;
    }
    else {
      return false;
    }
  }
}