import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/attendence_model.dart';
import 'package:yunusco_group/models/employee_attendance_model.dart';
import 'package:yunusco_group/models/members_model.dart';
import 'package:yunusco_group/models/payslip_model.dart';
import 'package:yunusco_group/models/single_emp_leave_history_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../models/JobCardDropdownModel.dart';
import '../models/leave_data_model.dart';
import '../models/leave_model.dart';
import '../models/self_leave_info.dart';
import '../models/vehicle_model.dart';

class HrProvider extends ChangeNotifier{
  ApiService apiService=ApiService();


  List<AttendenceModel> _allDeptAttendanceList=[];
  List<AttendenceModel> get allDeptAttendanceList =>_allDeptAttendanceList;

  Future<bool> getAllDepertmentsAttendance(DateTime datetime) async{

    String date= formatDateSlash(datetime);

    var data=await apiService.getData('api/User/DepartmentAttendance?Date=${date}&Department=0');
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
    return '$month-$day-${date.year}';
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
    var data=await apiService.getData('api/User/EmpJobcardReport?IdCard=$name&fromDate=$formattedFromDate&toDate=$formattedToDate&Departmant=0&Section=0&ProductionUnit=0&ProductionLine=0');
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
    //http://192.168.15.6:8090/api/Leave/GetRcntPenLevLst?IdCard=31401
    var data=await apiService.getData('api/Leave/GetRcntPenLevLst?IdCard=${DashboardHelpers.currentUser!.iDnum}');
    setLoading(false);
    if(data!=null){
      _leaveDataList.clear();
      for(var i in data['Results']){
        _leaveDataList.add(LeaveDataModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_leaveDataList ${_leaveDataList.length}');
    }
  }

  SelfLeaveInfo? _selfLeaveInfo;
  SelfLeaveInfo? get selfLeaveInfo=>_selfLeaveInfo;

  List<LeaveBalance> _leaveTypeList=[];
  List<LeaveBalance> get leaveTypeList=>_leaveTypeList;

  Future<void> getLeaveApplicationInfo() async{

    setLoading(true);
     var data=await apiService.getData('api/Leave/GetSingleEmpLeaveBalance/${DashboardHelpers.currentUser!.iDnum}');
     setLoading(false);

    if(data!=null){
      _selfLeaveInfo=SelfLeaveInfo.fromJson(data['Results']);
      _leaveTypeList=convertToLeaveBalances(_selfLeaveInfo!.toJson());
    }
    debugPrint('leaveList ${_leaveTypeList.length}');
    notifyListeners();

  }

  Future<bool> submitApplicationForLeave(DateTime? fromDate, DateTime? toDate,File? attachment, String reason,LeaveBalance leaveType,int dayCount) async{
    var data=await apiService.uploadImageWithData(

      url: 'api/Leave/SubmitLeaveRequest',
        imageFile: attachment,
      formData: {
        "UserId" : DashboardHelpers.currentUser!.userId,
        "IdCardNo": DashboardHelpers.currentUser!.iDnum,
        "LeaveFromDate": DashboardHelpers.convertDateTime(fromDate.toString(),pattern: 'yyyy-MM-dd'),
        "LeaveToDate": DashboardHelpers.convertDateTime(toDate.toString(),pattern: 'yyyy-MM-dd'),
        "LeaveType": leaveType.policyId,
        "LeaveBalance": dayCount,
        "Reasons": reason,
        "DocumentFile":attachment,
        "remainingLeaveDay": leaveType.remaining,
        "policyId": leaveType.policyId,
        "IsFirst": false
      }
    );
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


  List<SingleEmpLeaveHistoryModel> _singleEmpLeaveList=[];
  List<SingleEmpLeaveHistoryModel> get singleEmpLeaveList=>_singleEmpLeaveList;

  Future<void> getSingleEmployeeLeaveHistory() async{
    var data=await apiService.getData('api/Leave/SingleEmpLeaveHistory?IdCard=${DashboardHelpers.currentUser!.iDnum}');

    if(data!=null){
      _singleEmpLeaveList.clear();
      for(var i in data['Results']){
        _singleEmpLeaveList.add(SingleEmpLeaveHistoryModel.fromJson(i));
      }
    }
    debugPrint('_singleEmpLeaveList ${_singleEmpLeaveList.length}');
    notifyListeners();

  }
  
  

  Future<PayslipModel?> getPaySlipInfo(String month,String year) async{
    setLoading(true);
    var response=await apiService.postData('api/hr/GetPayslip', {
        "Company": 1,
        "DepartmenmtId": 0,
        "SectionId": 0,
        "UnitiD": 0,
        "LineId": 0,
        "DesignationId": 0,
        "SalaryMonth": month,
        "SalaryYear": year,
        "ReportType": 6,
        "CompanyText": "Yunusco (BD) Limited",
        "IdList": DashboardHelpers.currentUser!.iDnum,
        "Grade": 0,
        "DivisionId": 0,
        "IsM": false,
        "UserType": "COM"
    });
    setLoading(false);
    return response==null?null:response['Data'].isEmpty?null: PayslipModel.fromJson(response['Data'][0]);
  }

  JobCardDropdownModel? allDropdownInfoForJobcard;

  Future<void> getAllDropdownInfoForJobcard() async{
    var data=await apiService.getData('api/HR/SalaryReportDropDown');
    if(data!=null){
      allDropdownInfoForJobcard = JobCardDropdownModel.fromJson(data['Result']);
    }
    notifyListeners();
  }





  final List<MembersModel> _member_list = [];

  List<MembersModel> get member_list => _member_list;

  Future<void> selectDeselect(MembersModel member) async {
    member.isSelected = !member.isSelected;
    notifyListeners();
  }

  void toggleSelection(int index) {
    _member_list[index].isSelected = !_member_list[index].isSelected;
    notifyListeners();
  }

  Future<void> getAllStuffList() async{
    var data=await apiService.getData('api/Test/StaffEmpData');
    if(data!=null){
      _member_list.clear();
      for(var i in data){
        _member_list.add(MembersModel.fromJson(i));
      }
    }
    debugPrint('_member_list ${_member_list.length}');
    notifyListeners();
  }

  Future<bool> saveVehicleRequisation(dynamic formData) async{
    var result=await apiService.postData('api/Inventory/SaveVehicleRequisition', formData);
    return result==null?false:true;
  }


  List<VehicleModel> _vehicleList=[];


  List<VehicleModel> get vehicleList => _vehicleList;

  Future<void> getRequestedCarList() async{

    var data=await apiService.getData('api/inventory/UserWiseVehicleRequisitionList');
    if(data!=null){
      _vehicleList.clear();
      for(var i in data['returnvalue']){
        _vehicleList.add(VehicleModel.fromJson(i));
      }
    }
    debugPrint('_vehicleList ${_vehicleList.length}');
    notifyListeners();
  }

  Future<bool> acceptVehicleRequisation(dynamic data) async {
    var result=await apiService.postData('api/Inventory/RequisitionApproved', data);
    return result==null?false:true;
  }
  Future<bool> rejectVehicleRequisation(dynamic data) async {
    var result=await apiService.postData('api/Inventory/RequisitionReject', data);
    return result==null?false:true;
  }


}