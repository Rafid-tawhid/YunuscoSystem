import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/attendence_model.dart';
import 'package:yunusco_group/models/employee_attendance_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../models/leave_data_model.dart';
import '../models/leave_model.dart';
import '../models/self_leave_info.dart';

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



  List<EmployeeAttendanceModel> _employeeAttendanceList=[];
  List<EmployeeAttendanceModel> get employeeAttendanceList =>_employeeAttendanceList;
  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  setLoading(bool val){
    _isLoading=val;
    notifyListeners();
  }

  Future<bool> getEmployeeAttendance(String name, String formattedFromDate, String formattedToDate) async{

    setLoading(true);
    var data=await apiService.getData('api/HrApi/JobCardReport?userName=$name&fromDate=$formattedFromDate&toDate=$formattedToDate&Departmant=0&Section=0&ProductionUnit=0&ProductionLine=0');
    setLoading(false);
    if(data!=null){
      _employeeAttendanceList.clear();
      for(var i in data){
        _employeeAttendanceList.add(EmployeeAttendanceModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_employeeAttendanceList ${_employeeAttendanceList.length}');
      return true;
    }
    else {
      return false;
    }
  }


  List<LeaveDataModel> _leaveDataList=[];
  List<LeaveDataModel> get leaveDataList=>_leaveDataList;

  void getPersonalAttendance() async{
    setLoading(true);
    var data=await apiService.getData('api/HrApi/LeaveHistoryList?EmployeeID=${DashboardHelpers.currentUser!.iDnum}');
    setLoading(false);
    if(data!=null){
      _leaveDataList.clear();
      for(var i in data){
        _leaveDataList.add(LeaveDataModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_leaveDataList ${_leaveDataList.length}');

    }
  }
  //

  SelfLeaveInfo? _selfLeaveInfo;
  SelfLeaveInfo? get selfLeaveInfo=>_selfLeaveInfo;

  List<LeaveBalance> _leaveTypeList=[];
  List<LeaveBalance> get leaveTypeList=>_leaveTypeList;

  Future<void> getLeaveApplicationInfo() async{
     var data=await apiService.getData2('http://192.168.15.6:8090/api/Leave/GetSingleEmpLeaveBalance/${DashboardHelpers.currentUser!.iDnum}');

    if(data!=null){
      _selfLeaveInfo=SelfLeaveInfo.fromJson(data['Results']);
      _leaveTypeList=convertToLeaveBalances(_selfLeaveInfo!.toJson());
    }
    debugPrint('leaveList ${_leaveTypeList.length}');
    notifyListeners();

  }

  Future<bool> submitApplicationForLeave(DateTime? fromDate, DateTime? toDate, String reason,LeaveBalance leaveType) async{
    var data=await apiService.postData2('http://192.168.15.6:8090/api/Leave/SubmitLeaveRequest', {
      "UserId" : DashboardHelpers.currentUser!.userId,
      "IdCardNo": DashboardHelpers.currentUser!.iDnum,
      "LeaveFromDate": DashboardHelpers.convertDateTime(fromDate.toString(),pattern: 'yyyy-MM-dd'),
      "LeaveToDate": DashboardHelpers.convertDateTime(toDate.toString(),pattern: 'yyyy-MM-dd'),
      "LeaveType": leaveType.policyId,
      "LeaveBalance": leaveType.total,
      "Reasons": reason,
      "remainingLeaveDay": leaveType.remaining,
      "policyId": leaveType.policyId,
      "IsFirst": false
    });
    return data==null?false:true;
  }


  List<LeaveBalance> convertToLeaveBalances(Map<String, dynamic> json) {
    return [
      LeaveBalance(
        type: 'Sick Leave',
        used: json['SickLeave'] ?? 0,
        total: json['SickLeavePolicyDays'] ?? 0,
        policyType: json['SickLeavePolicyType'] ?? '',
        policyId: json['SickLeavePolicyId'] ?? 0,
      ),
      LeaveBalance(
        type: 'Casual Leave',
        used: json['CasualLeave'] ?? 0,
        total: json['CasualLeavePolicyDays'] ?? 0,
        policyType: json['CasualLeavePolicyType'] ?? '',
        policyId: json['CasualLeavePolicyId'] ?? 0,
      ),
      LeaveBalance(
        type: 'Maternity Leave',
        used: json['MaternityLeave'] ?? 0,
        total: json['MaternityLeavePolicyDays'] ?? 0,
        policyType: json['MaternityLeavePolicyType'] ?? '',
        policyId: json['MaternityLeavePolicyId'] ?? 0,
      ),
      LeaveBalance(
        type: 'Earn Leave',
        used: json['EarnLeave'] ?? 0,
        total: json['EarnLeavePolicyDays'] ?? 0,
        policyType: json['EarnLeavePolicyType'] ?? '',
        policyId: json['EarnLeavePolicyId'] ?? 0,
      ),
      LeaveBalance(
        type: 'Leave Without Pay',
        used: json['LeaveWithoutPay'] ?? 0,
        total: json['LeaveWithoutPayPolicyDays'] ?? 0,
        policyType: json['LeaveWithoutPayPolicyType'] ?? '',
        policyId: json['LeaveWithoutPayPolicyId'] ?? 0,
      ),
    ];
  }
}