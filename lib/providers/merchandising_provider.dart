import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/models/buyer_wise_value_model.dart';
import 'package:yunusco_group/models/purchase_approval_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../models/bom_model.dart';
import '../models/buyer_order_details_model.dart';
import '../models/costing_approval_list_model.dart';
import '../models/work_order_model.dart';

class MerchandisingProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  BuyerWiseValueModel? _buyerWiseValueModel;
  BuyerWiseValueModel? get buyerWiseValueModel => _buyerWiseValueModel;

  Future<void> getAllMerchandisingInfo() async {
    debugPrint('This is data calling...}');
    var data = await apiService.getData('api/Dashboard/BuyerWiseValue');
    debugPrint('This is data $data');
    if (data != null) {
      _buyerWiseValueModel = BuyerWiseValueModel.fromJson(data['returnvalue']);
      //  debugPrint('buyerWiseValueModel ${buyerWiseValueModel!.toJson()}');
    }

    notifyListeners();
  }

  final List<BuyerOrderDetailsModel> _allBuyerOrderList = [];
  List<BuyerOrderDetailsModel> _filteredBuyerOrderList = [];
  List<BuyerOrderDetailsModel> get allBuyerOrderList => _filteredBuyerOrderList;

  Future<bool> getAllBuyerOrders() async {
    var data = await apiService.getData(
        'api/Merchandising/BuyerOrderAppListDateRange?fromDate=2025-01-01&toDate=2025-07-21');
    //var data=await apiService.getData('api/Merchandising/BuyerOrderAppList');
    if (data != null) {
      _allBuyerOrderList.clear();
      for (var i in data['result']['Result']) {
        _allBuyerOrderList.add(BuyerOrderDetailsModel.fromJson(i));
      }
      _filteredBuyerOrderList = _allBuyerOrderList;
      notifyListeners();
      debugPrint('_allBuyerOrderList ${_allBuyerOrderList.length}');
      return true;
    } else {
      return false;
    }
  }

  //search
  void searchOrders(String query) {
    if (query.isEmpty) {
      _filteredBuyerOrderList = _allBuyerOrderList;
    } else {
      _filteredBuyerOrderList = _allBuyerOrderList.where((order) {
        return (order.masterOrderCode
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (order.styleName?.toString().contains(query) ?? false) ||
            (order.buyerName?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (order.masterOrderCode
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false);
      }).toList();
    }
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<CostingApprovalListModel> _costingApprovalList = [];
  List<CostingApprovalListModel> get costingApprovalList =>
      _costingApprovalList;
  List<CostingApprovalListModel> _costingApprovalFilterList = [];
  List<CostingApprovalListModel> get costingApprovalFilterList =>
      _costingApprovalFilterList;

  Future<bool> getCostingApprovalList(String uId) async {
    try {
      setLoading(true);
      //615
      var data =
          await apiService.getData('api/Merchandising/CostingApprovalList');
      if (data != null) {
        _costingApprovalList.clear();
        _costingApprovalFilterList.clear();
        for (var i in data['returnvalue']['Result']) {
          _costingApprovalList.add(CostingApprovalListModel.fromJson(i));
        }
        _costingApprovalFilterList.addAll(_costingApprovalList);
        debugPrint('_costingApprovalList ${_costingApprovalList.length}');
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      setLoading(false);
      debugPrint('Error fetching costing approval list: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void clearSearch() {
    _costingApprovalFilterList = List.from(_costingApprovalList);
    notifyListeners();
  }

  Future<void> searchCostingApprovals(String query) async {
    if (query.isEmpty) {
      // If search query is empty, restore original list
      _costingApprovalFilterList = List.from(_costingApprovalList);
    } else {
      // Filter the list based on search query
      _costingApprovalFilterList = _costingApprovalList.where((item) {
        // Convert all comparisons to lowercase for case-insensitive search
        final searchLower = query.toLowerCase();
        // Search in all relevant fields
        return (item.finalStatus
                    ?.toLowerCase()
                    .contains(searchLower) ??
                false) ||
            (item.costingCode?.toLowerCase().contains(searchLower) ?? false) ||
            (item.buyerName?.toLowerCase().contains(searchLower) ?? false) ||
            (item.styleName?.toLowerCase().contains(searchLower) ?? false) ||
            (item.catagoryName?.toLowerCase().contains(searchLower) ?? false) ||
            (item.styleRef?.toLowerCase().contains(searchLower) ?? false) ||
            (item.createdBy?.toLowerCase().contains(searchLower) ?? false) ||
            (item.submitToPerson?.toLowerCase().contains(searchLower) ??
                false) ||
            (item.qtyType?.toLowerCase().contains(searchLower) ?? false) ||
            (item.id?.toString().contains(searchLower) ?? false);
      }).toList();
    }

    notifyListeners();
  }

  Future<dynamic> acceptRejectConstingApproval(dynamic approvalItem,
      {required String url}) async {
    ///HR/Approval/CommonReject
    ///HR/Approval/ApproveNew
    return apiService.postData(url, approvalItem);
  }

  List<PurchaseApprovalModel> _purchaseApprovalList = [];
  List<PurchaseApprovalModel> get purchaseApprovalList => _purchaseApprovalList;

  Future<bool> getAllPurchaseData() async {
    try {
      setLoading(true);
      debugPrint('Fetching purchase data...');

      final response = await apiService
          .getData('api/Merchandising/PurchaseOrderApprovalList');

      if (response == null || response['returnvalue'] == null) {
        debugPrint('No data received or invalid response structure');
        return false;
      }

      final result = response['returnvalue'] as List?;
      if (result == null || result.isEmpty) {
        debugPrint('Empty purchase data received');
        _purchaseApprovalList.clear();
        notifyListeners();
        return true;
      }

      _purchaseApprovalList = result
          .map<PurchaseApprovalModel>(
              (json) => PurchaseApprovalModel.fromJson(json))
          .toList();

      debugPrint(
          'Successfully loaded ${_purchaseApprovalList.length} purchase items');
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      debugPrint('Error fetching purchase data: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<dynamic> purchaseDetailsByPO(PurchaseApprovalModel purchase) async {
    return apiService.postData('api/Merchandising/DetailPurOrderMasterInfo',
        {"PO": purchase.purchaseOrderCode, "Version": purchase.version});
  }

  final List<WorkOrderModel> _workOrderList = [];
  List<WorkOrderModel> get workOrderList => _workOrderList;

  Future<void> getAllWorkOrder(
      {required DateTime from, required DateTime to}) async {
    try {
      // Format dates to 'yyyy-MM-dd' format for the API
      final fromDateStr = DateFormat('yyyy-MM-dd').format(from);
      final toDateStr = DateFormat('yyyy-MM-dd').format(to);

      // Use the formatted dates in the API URL
      var response = await apiService.getData(
          'api/Merchandising/WorkOrderList?fromDate=$fromDateStr&toDate=$toDateStr');

      if (response != null && response['result'] != null) {
        _workOrderList.clear();
        for (var i in response['result']) {
          _workOrderList.add(WorkOrderModel.fromJson(i));
        }
        notifyListeners();
        debugPrint(
            'Fetched ${_workOrderList.length} work orders from $fromDateStr to $toDateStr');
      } else {
        debugPrint('No data received from API');
        _workOrderList.clear();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching work orders: $e');
      // Consider adding error handling here, like showing a snackbar
      rethrow; // Or handle the error as needed
    }
  }

  dynamic _workOrderDetails;
  dynamic get workOrderDetails => _workOrderDetails;

  Future<bool> getWorderOrderDetails(String? code) async {
    var data = await apiService
        .getData('api/Merchandising/GetWorkOrderData?workOrderCode=$code');
    if (data != null) {
      _workOrderDetails = data['result'];
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  //CHANGE 7 AUG

  final List<BomModel> _bomList = [];
  List<BomModel> _filteredBomList = [];
  final bool _showSubmittedOnly = false;
  final bool _showLockedOnly = false;
  String _searchQuery = '';

  List<BomModel> get bomList => _bomList;
  List<BomModel> get filteredBomList => _filteredBomList;
  bool get showSubmittedOnly => _showSubmittedOnly;
  bool get showLockedOnly => _showLockedOnly;

  Future<void> fetchBomList(
      {required String fromDate, required String toDate}) async {
    setLoading(true);
    try {
      // Replace with your actual API call
      final response = await apiService.getData(
          'api/Merchandising/BomListDateRange?FromDate=$fromDate&ToDate=$toDate');

      _bomList.clear();
      for (var i in response['returnvalue']) {
        _bomList.add(BomModel.fromJson(i));
      }
      debugPrint('_bomList ${_bomList.length}');
      _filteredBomList = _applyFilters(_bomList);
    } catch (e) {
      // Handle error
    } finally {
      setLoading(false);
    }
  }

  void searchBoms(String query) {
    _searchQuery = query.toLowerCase();
    _filteredBomList = _applyFilters(_bomList);
    notifyListeners();
  }

  List<BomModel> _applyFilters(List<BomModel> list) {
    return list.where((bom) {
      final matchesSearch = _searchQuery.isEmpty ||
          (bom.bOMCode?.toLowerCase().contains(_searchQuery) == true) ||
          (bom.styleName?.toLowerCase().contains(_searchQuery) == true) ||
          (bom.buyer?.toLowerCase().contains(_searchQuery) == true);

      final matchesSubmitted = !_showSubmittedOnly || bom.isSubmit == true;
      final matchesLocked = !_showLockedOnly || bom.isLock == true;

      return matchesSearch && matchesSubmitted && matchesLocked;
    }).toList();
  }
}
