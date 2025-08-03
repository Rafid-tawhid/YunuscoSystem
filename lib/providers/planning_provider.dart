import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/models/buyer_wise_material_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../models/line_setup_model.dart';

class PlanningProvider extends ChangeNotifier{
  ApiService apiService=ApiService();

  List<LineSetupModel> _allPlanningList=[];
  List<LineSetupModel> get allPlanningList=>_allPlanningList;

  Future<bool> getAllPlanningList(String date) async{
    var data=await apiService.getData('api/Manufacturing/TargetLineSetup?date=$date');
    if(data!=null){
      _allPlanningList.clear();
      for(var i in data['returnvalue']){
        _allPlanningList.add(LineSetupModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_allPlanningList ${_allPlanningList.length}');
      return true;
    }
    else {
      return false;
    }

  }

}
