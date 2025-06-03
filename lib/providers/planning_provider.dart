import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/models/buyer_wise_material_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'package:yunusco_group/utils/constants.dart';

class PlanningProvider extends ChangeNotifier{
  ApiService apiService=ApiService();

  List<Map<String,dynamic>> _allPlanningList=[];
  List<Map<String,dynamic>> get allPlanningList=>_allPlanningList;

  Future<bool> getAllPlanningList() async{
    var data=await apiService.getData('api/Merchandising/AllPO');
    if(data!=null){
      _allPlanningList.clear();
      for(var i in data['result']['returnvalue']){
        _allPlanningList.add(i);
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
