import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';

import '../models/access_type_model.dart';
import '../models/pf_main_model.dart';
import '../service_class/api_services.dart';

class AccountProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  final List<PfMainModel> _pfList = [];
  List<PfMainModel> _filteredPfList = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<PfMainModel> get pfList => _pfList;
  List<PfMainModel> get filteredPfList => _filteredPfList;
  bool get isLoading => _isLoading;

  Future<void> fetchPfList() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await apiService.getData('api/Hr/PfSettlement');

      if (data != null) {
        for (var i in data['Result']) {
          _pfList.add(PfMainModel.fromJson(i));
        }
      }
      debugPrint('_pfList ${_pfList.length}');
      _filteredPfList = _applyFilters(_pfList);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchPfRecords(String query) {
    _searchQuery = query.toLowerCase();
    _filteredPfList = _applyFilters(_pfList);
    notifyListeners();
  }

  List<PfMainModel> _applyFilters(List<PfMainModel> list) {
    return list.where((pf) {
      return _searchQuery.isEmpty ||
          (pf.employeeName?.toLowerCase().contains(_searchQuery) == true) ||
          (pf.pfvoucherNo?.toLowerCase().contains(_searchQuery) == true) ||
          (pf.idCardNo?.toLowerCase().contains(_searchQuery) == true) ||
          (pf.department?.toLowerCase().contains(_searchQuery) == true) ||
          (pf.designation?.toLowerCase().contains(_searchQuery) == true);
    }).toList();
  }

  Future<bool> changePassword(String name, String oldPass, newPass) async {
    var response = await apiService.patchData('api/User/UpdatePassword', {"LoginName": name, "OldPassword": oldPass, "NewPassword": newPass, "RetypePassword": newPass});
    return response == null ? false : true;
  }

  Map<String, dynamic>? personalPfInfo;

  Future<Map<String, dynamic>?> fetchPfAmount() async {
    try {
      final data = await apiService.getData('api/HR/PFStatus/${DashboardHelpers.currentUser!.userId}');
      if (data != null) {
        personalPfInfo = data['Results'][0];
        return personalPfInfo;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Something wrong $e');
      return null;
    }
  }

  List<AccessTypeModel> _accessList = [];
  List<AccessTypeModel> get accessList => _accessList;
  Future<void> getAccessType() async {
    var data = await apiService.getData('api/User/UserAccessTypes');
    if (data != null) {
      _accessList.clear();
      for (var i in data['Results']) {
        _accessList.add(AccessTypeModel.fromJson(i));
      }
    }
    debugPrint('_accessList ${_accessList.length}');
    notifyListeners();
  }

  Future<dynamic> saveUserRole(String id, String? selectedUserRole, AccessTypeModel? selectedAccessType) async {

   return apiService.postData('api/User/SaveUAccessRoles', {
        "UserId" : id,
        "Role" : selectedUserRole,
        "AccessTypeId" : selectedAccessType!.accessTypeId
    });
  }

  Future<bool> saveUserAccess(String accType) async {

    var data =await apiService.postFormData('api/User/SaveUAccessType',{
      'accessType':accType
    });

    return data!=null?true:false;
  }
}
