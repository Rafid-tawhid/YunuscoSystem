import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../models/management_dashboard_model.dart';
import '../utils/constants.dart';

class ManagementProvider extends ChangeNotifier{
  ApiService apiService=ApiService();
  ManagementDashboardModel? _managementDashboardData;
  ManagementDashboardModel? get managementDashboardData=>_managementDashboardData;

  Future<void> getAllManagementInfo() async {
    var data= await apiService.getData2('${AppConstants.baseUrl}Manufacturing/Cutting/ProductionDashBoard');
    if(data!=null){
      _managementDashboardData=ManagementDashboardModel.fromJson(data['returnvalue']);
       //debugPrint('_managementDashboardData ${_managementDashboardData!.toJson()}');
    }

    debugPrint('_managementDashboardData ${_managementDashboardData!.toJson()}');

    notifyListeners();
  }
}