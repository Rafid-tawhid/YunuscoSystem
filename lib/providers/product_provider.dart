import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yunusco_group/models/buyer_wise_material_model.dart';
import 'package:yunusco_group/models/production_dashboard_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'package:yunusco_group/utils/constants.dart';

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
    setLoading(true);
    var data=await apiService.getData('api/PreSalesApi/BuyerWiseMaterialList?buyerId=$code');
    setLoading(false);
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


  List<Map<String,dynamic>> _productionSummaryList=[];
  List<Map<String,dynamic>> get productionSummaryList=>_productionSummaryList;


  Future<bool> getProductionSummary(String month,String year,String section) async {

    setLoading(true);
    var data=await apiService.getData('api/Merchandising/ProductionSummary?section=$section&month=$month&year=$year');
    setLoading(false);
    if(data!=null){
      _productionSummaryList.clear();
      for(var i in data['returnvalue']){
        _productionSummaryList.add(i);
      }
      notifyListeners();
      debugPrint('_productionSummaryList ${_productionSummaryList.length}');
      return _productionSummaryList.isNotEmpty?true:false;
    }
    else {
      return false;
    }
  }



  ProductionDashboardModel? _productionDashboardModel;
  ProductionDashboardModel? get productionDashboardModel => _productionDashboardModel;
  //dashboard
  Future<bool> getAllProductionDashboard() async{
    var data=await apiService.getData('api/dashboard/ProductionDashBoard');
    if(data!=null){
      _productionDashboardModel=ProductionDashboardModel.fromJson(data['returnvalue']);
      notifyListeners();
      debugPrint('_allCategoryList ${_productionDashboardModel!.unitWiseSewing!.length}');
      return true;
      }
    else {
      return false;
    }

  }
}