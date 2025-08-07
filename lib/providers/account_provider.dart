import 'package:flutter/cupertino.dart';

import '../models/pf_main_model.dart';
import '../service_class/api_services.dart';

class AccountProvider extends ChangeNotifier{
  ApiService apiService=ApiService();
  List<PfMainModel> _pfList = [];
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
      final data = await apiService.getData2('http://202.74.243.118:8090/api/Hr/PfSettlement');

      if(data!=null){
        for(var i in data['Result']){
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
}