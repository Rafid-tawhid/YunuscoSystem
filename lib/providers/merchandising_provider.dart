import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/buyer_wise_value_model.dart';
import 'package:yunusco_group/screens/Merchandising/buyer_order_details.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../models/buyer_order_details_model.dart';
import '../models/costing_approval_list_model.dart';

class MerchandisingProvider extends ChangeNotifier{

  ApiService apiService=ApiService();
  BuyerWiseValueModel? _buyerWiseValueModel;
  BuyerWiseValueModel? get buyerWiseValueModel=>_buyerWiseValueModel;

  Future<void> getAllMerchandisingInfo() async {
    debugPrint('This is data calling...}');
    var data= await apiService.getData('api/Dashboard/BuyerWiseValue');
    debugPrint('This is data ${data}');
    if(data!=null){
      _buyerWiseValueModel=BuyerWiseValueModel.fromJson(data['returnvalue']);
    //  debugPrint('buyerWiseValueModel ${buyerWiseValueModel!.toJson()}');
    }

    notifyListeners();
  }


  List<BuyerOrderDetailsModel> _allBuyerOrderList=[];
  List<BuyerOrderDetailsModel> _filteredBuyerOrderList = [];
  List<BuyerOrderDetailsModel> get allBuyerOrderList => _filteredBuyerOrderList;

  Future<bool> getAllBuyerOrders() async{
    var data=await apiService.getData('api/Merchandising/Buyerorder');
    if(data!=null){
      _allBuyerOrderList.clear();
      for(var i in data['result']['returnvalue']){
        _allBuyerOrderList.add(BuyerOrderDetailsModel.fromJson(i));
      }
      _filteredBuyerOrderList = _allBuyerOrderList;
      notifyListeners();
      debugPrint('_allBuyerOrderList ${_allBuyerOrderList.length}');
      return true;
    }
    else {
      return false;
    }

  }

  //search
  void searchOrders(String query) {
    if (query.isEmpty) {
      _filteredBuyerOrderList = _allBuyerOrderList;
    } else {
      _filteredBuyerOrderList = _allBuyerOrderList.where((order) {
        return (order.masterOrderCode?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (order.buyer?.toString().contains(query) ?? false) ||
            (order.orderNumber?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (order.approvalStatus?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
    }
    notifyListeners();
  }



  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  List<CostingApprovalListModel> _costingApprovalList=[];
  List<CostingApprovalListModel> get costingApprovalList=>_costingApprovalList;
  List<CostingApprovalListModel> _costingApprovalFilterList=[];
  List<CostingApprovalListModel> get costingApprovalFilterList=>_costingApprovalFilterList;

  Future<bool> getCostingApprovalList(String uId) async{
    try {
      setLoading(true);
      //615
      var data = await apiService.getData('api/Merchandising/CostingApprovalList?userId=${uId}');
      if(data != null) {
        _costingApprovalList.clear();
        _costingApprovalFilterList.clear();
        for(var i in data['result']){
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

  setLoading(bool val){
    _isLoading=val;
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
        return (item.finalStatus?.toLowerCase().contains(searchLower) ?? false) ||
            (item.costingCode?.toLowerCase().contains(searchLower) ?? false) ||
            (item.buyerName?.toLowerCase().contains(searchLower) ?? false) ||
            (item.styleName?.toLowerCase().contains(searchLower) ?? false) ||
            (item.catagoryName?.toLowerCase().contains(searchLower) ?? false) ||
            (item.styleRef?.toLowerCase().contains(searchLower) ?? false) ||
            (item.createdBy?.toLowerCase().contains(searchLower) ?? false) ||
            (item.submitToPerson?.toLowerCase().contains(searchLower) ?? false) ||
            (item.qtyType?.toLowerCase().contains(searchLower) ?? false) ||
            (item.id?.toString().contains(searchLower) ?? false);
      }).toList();
    }

    notifyListeners();
  }

  Future<void> acceptRejectConstingApproval(dynamic approvalItem, {required String url}) async{
    ///HR/Approval/CommonReject
    ///HR/Approval/ApproveNew
    apiService.postData(url, approvalItem);
  }



}