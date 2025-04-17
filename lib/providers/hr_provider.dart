import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/models/attendence_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';

class HrProvider extends ChangeNotifier{
  ApiService apiService=ApiService();
  List<Map<String,dynamic>> _hrMenuList=[];
  List<Map<String,dynamic>> get hrMenuList =>_hrMenuList;

  Future<bool> getHRMenuList() async{
    var data=await apiService.getData('api/HrApi/AllDepartment');
    if(data!=null){
      _hrMenuList.clear();
      for(var i in data['returnvalue']){
        _hrMenuList.add(i);
      }
      notifyListeners();
      debugPrint('_hrMenuList ${_hrMenuList.length}');
      return true;
    }
    else {
      return false;
    }

  }


  List<AttendenceModel> _allDeptAttendanceList=[];
  List<AttendenceModel> get allDeptAttendanceList =>_allDeptAttendanceList;

  Future<bool> getAllDepertmentsAttendance(DateTime datetime) async{

    String date= formatDateSlash(datetime);

    var data=await apiService.getData('api/HrApi/DepartmentAttendance?Date=${date}&Department=0');
    if(data!=null){
      _allDeptAttendanceList.clear();
      for(var i in data){
        _allDeptAttendanceList.add(AttendenceModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_allDeptAttendanceList ${_allDeptAttendanceList.length}');
      return true;
    }
    else {
      return false;
    }
  }


  String formatDateSlash(DateTime date) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$month -$day - ${date.year}';
  }


  bool _showLeavHistory=false;
  bool get showLeavHistory=>_showLeavHistory;
  showAndHideLeaveHistory(){
    _showLeavHistory=!_showLeavHistory;
    notifyListeners();
  }
}