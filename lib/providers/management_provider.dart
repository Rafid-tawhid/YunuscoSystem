import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/models/JobCardDropdownModel.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../models/management_dashboard_model.dart';
import '../utils/constants.dart';

class ManagementProvider extends ChangeNotifier{
  ApiService apiService=ApiService();
  ManagementDashboardModel? _managementDashboardData;
  ManagementDashboardModel? get managementDashboardData=>_managementDashboardData;

  Future<void> getAllProductionStatInfo() async {
    var data= await apiService.getData2('${AppConstants.baseUrl}api/Dashboard/ProductionDashBoard');
    if(data!=null){
      _managementDashboardData=ManagementDashboardModel.fromJson(data['returnvalue']);
       //debugPrint('_managementDashboardData ${_managementDashboardData!.toJson()}');
    }

    debugPrint('_managementDashboardData ${_managementDashboardData!.toJson()}');

    notifyListeners();
  }


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  JobCardDropdownModel? allDropdownInfoForJobcard;

  Future<void> getAllDropdownInfoForJobcard() async{
    try {
      _isLoading = true;
      notifyListeners();
      var data=await apiService.getData('api/HR/SalaryReportDropDown');
      if(data!=null){
        allDropdownInfoForJobcard = JobCardDropdownModel.fromJson(data['Result']);
      }
    }
    catch(e){
      debugPrint('Error ${e}');
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}