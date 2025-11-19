import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/production_strength_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../models/css_model.dart';
import '../models/inventory_stock_model.dart';

class InventoryPorvider extends ChangeNotifier {
  ApiService apiService = ApiService();

  final List<InventoryStockModel> _inventoryStockList = [];
  List<InventoryStockModel> get inventoryStockList => _inventoryStockList;

  bool _loading=false;
  bool  get loading => _loading;

  setLoading(bool)
  {
    _loading=bool;
    notifyListeners();
  }

  //
  Future<bool> getInventoryStockSummary(DateTime date, String type) async {
    debugPrint('This is type $type');
    final formattedDate = formatDateSlash(date);
    var data = await apiService.getData(
        'api/Inventory/StockSummary?storeType=$type&toDate=$formattedDate');
    if (data != null) {
      _inventoryStockList.clear();
      for (var i in data['returnvalue']) {
        _inventoryStockList.add(InventoryStockModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_inventoryStockList ${_inventoryStockList.length}');
      return true;
    } else {
      return false;
    }
  }

  String formatDateSlash(DateTime date) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$month -$day - ${date.year}';
  }

  final List<ProductionStrengthModel> _productionStrengthList = [];
  List<ProductionStrengthModel> get productionStrengthList =>
      _productionStrengthList;

  Future<bool> getProductionStrengthInfo(DateTime dateTime) async {
    final formattedDate = DashboardHelpers.convertDateTime2(dateTime);
    var data = await apiService
        .getData('api/Dashboard/ProductionStregnth?date=$formattedDate');
    if (data != null) {
      _productionStrengthList.clear();
      for (var i in data['returnvalue']) {
        _productionStrengthList.add(ProductionStrengthModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_productionStrengthList ${_productionStrengthList.length}');
      return true;
    } else {
      return false;
    }
  }


  List<CssModel> _requisitions = [];
  List<CssModel> _filteredRequisitions = [];
  String _searchQuery = '';
  String _filterValue = 'All';

  List<CssModel> get requisitions => _requisitions;
  List<CssModel> get filteredRequisitions => _filteredRequisitions;
  String get searchQuery => _searchQuery;
  String get filterValue => _filterValue;

  Future<void> getAllCs() async{
    setLoading(true);
    var data=await apiService.getData('api/inventory/InvCSSList');
    setLoading(false);
    if(data!=null){
      _requisitions.clear();
      for (var i in data['returnvalue']) {
        _requisitions.add(CssModel.fromJson(i));
      }
      _filteredRequisitions=_requisitions;
    }
    notifyListeners();
    debugPrint('_requisitions ${_requisitions.length}');
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setFilterValue(String value) {
    _filterValue = value;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredRequisitions = _requisitions.where((requisition) {
      final matchesSearch = requisition.purchaseRequisitionCode
          !.toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          requisition.userName!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          requisition.code!.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesFilter = _filterValue == 'All' ||
          requisition.purchaseType == _filterValue ||
          requisition.type == _filterValue;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void addRequisition(CssModel requisition) {
    _requisitions.add(requisition);
    _applyFilters();
    notifyListeners();
  }
}
