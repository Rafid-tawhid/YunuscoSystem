import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yunusco_group/models/buyer_wise_material_model.dart';
import 'package:yunusco_group/models/production_dashboard_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../models/master_lc_model.dart';
import '../models/production_efficiency_model.dart';
import '../models/stylewise_efficiency_model.dart';

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
    var data=await apiService.getData('api/Merchandising/AllActiveOrderdBuyer');
    if(data!=null){
      _allBuyerList.clear();
      for(var i in data['returnvalue']['Result']){
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
    var data=await apiService.getData('api/Merchandising/MaterialListBuyerWise?buyerId=$code');
    setLoading(false);
    if(data!=null){
      _buyerMaterialList.clear();
      for(var i in data['returnvalue']['Result']){
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
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var data=await apiService.getData('api/dashboard/ProductionDashBoard');
    EasyLoading.dismiss();
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

  List<ProductionEfficiencyModel> _productionEfficiencyList=[];

  List<ProductionEfficiencyModel> get productionEfficiencyList=>_productionEfficiencyList;

  Future<bool> getProductionEfficiencyReport(String dateTime) async {

    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    setLoading(true);
    var data=await apiService.postData('api/Merchandising/ProductionEffiReport',{
        "ProductionDate": dateTime,
        "BuyerId": 0,
        "Style": "",
        "BuyerPO": "",
        "SectionId" : 0,
        "AchieveEfficiency": 0,
        "LineId": 0

    });
    setLoading(false);
    EasyLoading.dismiss();
    if(data!=null){
      _productionEfficiencyList.clear();
      for(var i in data['Data']){
        _productionEfficiencyList.add(ProductionEfficiencyModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_productionEfficiencyList ${_productionEfficiencyList.length}');
      return true;
    }
    else {
      return false;
    }
  }

  List<ProductionEfficiencyModel> getFilteredList({
    int? buyerId,
    int? sectionId,
    int? lineId,
    String? styleNo,
  }) {
    return _productionEfficiencyList.where((item) {
      final buyerMatch = buyerId == null || item.buyerId == buyerId;
      final sectionMatch = sectionId == null || item.sectionId == sectionId;
      final lineMatch = lineId == null || item.lineId == lineId;
      final styleMatch = styleNo == null || item.styleNo == styleNo;
      return buyerMatch && sectionMatch && lineMatch && styleMatch;
    }).toList();
  }

  List<DropdownMenuItem<int>> get buyerDropdownItems {
    // Create a map to ensure unique buyerId-buyerName pairs
    final uniqueBuyers = <int, String>{};

    for (final item in _productionEfficiencyList) {
      if (item.buyerId != null && item.buyerName != null) {
        uniqueBuyers[item.buyerId!.toInt()] = item.buyerName!;
      }
    }

    return uniqueBuyers.entries.map((entry) => DropdownMenuItem<int>(
      value: entry.key,
      child: Text(entry.value),
    )).toList();
  }


  List<DropdownMenuItem<int>> get sectionDropdownItems {
    final uniqueEntries = <int, String>{};

    for (final item in _productionEfficiencyList) {
      if (item.sectionId != null && item.sectionName != null &&
          !uniqueEntries.containsKey(item.sectionId)) {
        uniqueEntries[item.sectionId!.toInt()] = item.sectionName!;
      }
    }

    return uniqueEntries.entries.map((entry) => DropdownMenuItem<int>(
      value: entry.key,
      child: Text(entry.value),
    )).toList();
  }

  List<DropdownMenuItem<int>> get lineDropdownItems {
    final uniqueEntries = <int, String>{};

    for (final item in _productionEfficiencyList) {
      if (item.lineId != null && item.lineName != null &&
          !uniqueEntries.containsKey(item.lineId)) {
        uniqueEntries[item.lineId!.toInt()] = item.lineName!;
      }
    }

    return uniqueEntries.entries.map((entry) => DropdownMenuItem<int>(
      value: entry.key,
      child: Text(entry.value),
    )).toList();
  }

  List<DropdownMenuItem<String>> get styleDropdownItems {
    final uniqueEntries = <String, String>{};

    for (final item in _productionEfficiencyList) {
      if (item.styleNo != null && !uniqueEntries.containsKey(item.styleNo)) {
        uniqueEntries[item.styleNo!] = item.styleNo!;
      }
    }

    return uniqueEntries.entries.map((entry) => DropdownMenuItem<String>(
      value: entry.key,
      child: Text(entry.value),
    )).toList();
  }

  final List<StylewiseEfficiencyModel> _styleWiseEfficiencyList=[];
  List<StylewiseEfficiencyModel> get styleWiseEfficiencyList=>_styleWiseEfficiencyList;

  Future<bool> getStyleWiseEfficiency(String style) async{
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    setLoading(true);
    var data=await apiService.getData('api/Merchandising/StyleWiseEffi?styleName=$style');
    setLoading(false);
    EasyLoading.dismiss();
    if(data!=null){
      _styleWiseEfficiencyList.clear();
      for(var i in data['returnvalue']['Result']){
        _styleWiseEfficiencyList.add(StylewiseEfficiencyModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_styleWiseEfficiencyList ${_styleWiseEfficiencyList.length}');
      return true;
    }
    else {
      return false;
    }
  }


  void searchInStyleList(String query) {
    if (query.isEmpty) {
      // If search query is empty, restore original list
      _filteredBuyerStyleList = List.from(_buyerStyleList);
    } else {
      // Filter the list based on search query
      _filteredBuyerStyleList =
          _buyerStyleList.where((item) {
            // Convert all comparisons to lowercase for case-insensitive search
            final searchLower = query.toLowerCase();
            // Search in all relevant fields
            return (item.toString().toLowerCase().contains(searchLower) ?? false);
          }).toList();
    }

    notifyListeners();
  }

  List<String> _buyerStyleList = [];

  List<String> get buyerStyleList => _buyerStyleList;

  List<String> _filteredBuyerStyleList = [];

  List<String> get filteredStyleList => _filteredBuyerStyleList;

  Future<bool> getAllStyleData() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var data = await apiService.getData('api/Merchandising/StyleForEffiRpt');
    EasyLoading.dismiss();
    if (data != null) {
      _buyerStyleList.clear();
      _filteredBuyerStyleList.clear();
      for (var i in data['returnvalue']) {
        _buyerStyleList.add(i);
      }
      _filteredBuyerStyleList.addAll(_buyerStyleList);
      debugPrint('_buyerStyleList ${_buyerStyleList.length}');
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }


  bool _showFilter=true;
  bool get showFilter=>_showFilter;
  void showhideFilterSection(String? value) {
    if(value==null||value.isEmpty||value==''){
      _showFilter=true;
    }
    else {
      _showFilter=false;
    }
    notifyListeners();
  }



  final List<MasterLcModel> _masterLcList=[];
  List<MasterLcModel> get masterLcList=>_masterLcList;

  Future<bool> getMasterLcData(String query,int pgNum,int pgSize) async{
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var data = await apiService.getData('api/Merchandising/MasterLcListPages?searchText=$query&pageNumber=$pgNum&pageSize=10');
    EasyLoading.dismiss();
    if (data != null) {
      _masterLcList.clear();

      for (var i in data['data']) {
        _masterLcList.add(MasterLcModel.fromJson(i));
      }
      debugPrint('_masterLcList ${_masterLcList.length}');
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}