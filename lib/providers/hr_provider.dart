import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/attendence_model.dart';
import 'package:yunusco_group/models/doc_appoinment_list_model.dart';
import 'package:yunusco_group/models/employee_attendance_model.dart';
import 'package:yunusco_group/models/members_model.dart';
import 'package:yunusco_group/models/payslip_model.dart';
import 'package:yunusco_group/models/single_emp_leave_history_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../models/JobCardDropdownModel.dart';
import '../models/employee_appointment_info_model.dart';
import '../models/leave_data_model.dart';
import '../models/leave_model.dart';
import '../models/medicine_model.dart';
import '../models/prescription_medicine.dart';
import '../models/self_leave_info.dart';
import '../models/vehicle_model.dart';
import '../service_class/api_services.dart';

class HrProvider extends ChangeNotifier {
  ApiService apiService = ApiService();

  final List<AttendenceModel> _allDeptAttendanceList = [];
  List<AttendenceModel> get allDeptAttendanceList => _allDeptAttendanceList;

  Future<bool> getAllDepertmentsAttendance(DateTime datetime) async {
    String date = formatDateSlash(datetime);

    var data = await apiService
        .getData('api/User/DepartmentAttendance?Date=$date&Department=0');
    if (data != null) {
      _allDeptAttendanceList.clear();
      for (var i in data) {
        _allDeptAttendanceList.add(AttendenceModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_allDeptAttendanceList ${_allDeptAttendanceList.length}');
      return true;
    } else {
      return false;
    }
  }

  String formatDateSlash(DateTime date) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$month-$day-${date.year}';
  }

  bool _showLeavHistory = false;
  bool get showLeavHistory => _showLeavHistory;
  showAndHideLeaveHistory() {
    _showLeavHistory = !_showLeavHistory;
    notifyListeners();
  }

  final List<EmployeeAttendanceModel> _employeeAttendanceList = [];
  List<EmployeeAttendanceModel> get employeeAttendanceList =>
      _employeeAttendanceList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<bool> getEmployeeAttendance(
      String name, String formattedFromDate, String formattedToDate) async {
    setLoading(true);
    var data = await apiService.getData(
        'api/User/EmpJobcardReport?IdCard=$name&fromDate=$formattedFromDate&toDate=$formattedToDate&Departmant=0&Section=0&ProductionUnit=0&ProductionLine=0');
    setLoading(false);
    if (data != null) {
      _employeeAttendanceList.clear();
      for (var i in data) {
        _employeeAttendanceList.add(EmployeeAttendanceModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_employeeAttendanceList ${_employeeAttendanceList.length}');
      return true;
    } else {
      return false;
    }
  }

  final List<LeaveDataModel> _leaveDataList = [];
  List<LeaveDataModel> get leaveDataList => _leaveDataList;

  void getPersonalAttendance() async {
    setLoading(true);
    //http://192.168.15.6:8090/api/Leave/GetRcntPenLevLst?IdCard=31401
    var data = await apiService.getData(
        'api/Leave/GetRcntPenLevLst?IdCard=${DashboardHelpers.currentUser!.iDnum}');
    setLoading(false);
    if (data != null) {
      _leaveDataList.clear();
      for (var i in data['Results']) {
        _leaveDataList.add(LeaveDataModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_leaveDataList ${_leaveDataList.length}');
    }
  }

  SelfLeaveInfo? _selfLeaveInfo;
  SelfLeaveInfo? get selfLeaveInfo => _selfLeaveInfo;

  List<LeaveBalance> _leaveTypeList = [];
  List<LeaveBalance> get leaveTypeList => _leaveTypeList;

  Future<void> getLeaveApplicationInfo() async {
    setLoading(true);
    var data = await apiService.getData('api/Leave/GetSingleEmpLeaveBalance/${DashboardHelpers.currentUser!.iDnum}');
    setLoading(false);

    if (data != null) {
      _selfLeaveInfo = SelfLeaveInfo.fromJson(data['Data']);
      _leaveTypeList = convertToLeaveBalances(_selfLeaveInfo!.toJson());
    }
    debugPrint('leaveList ${_leaveTypeList.length}');
    notifyListeners();
  }

  Future<bool> submitApplicationForLeave(
      DateTime? fromDate,
      DateTime? toDate,
      File? attachment,
      String reason,
      LeaveBalance leaveType,
      int dayCount) async {
    var data = await apiService.uploadImageWithData(
        url: 'api/Leave/SubmitLeaveRequest',
        imageFile: attachment,
        formData: {
          "UserId": DashboardHelpers.currentUser!.userId,
          "IdCardNo": DashboardHelpers.currentUser!.iDnum,
          "LeaveFromDate": DashboardHelpers.convertDateTime(fromDate.toString(),
              pattern: 'yyyy-MM-dd'),
          "LeaveToDate": DashboardHelpers.convertDateTime(toDate.toString(),
              pattern: 'yyyy-MM-dd'),
          "LeaveType": leaveType.policyId,
          "LeaveBalance": dayCount,
          "Reasons": reason,
          "DocumentFile": attachment,
          "remainingLeaveDay": leaveType.remaining,
          "policyId": leaveType.policyId,
          "IsFirst": false
        });
    return data == null ? false : true;
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

  final List<SingleEmpLeaveHistoryModel> _singleEmpLeaveList = [];
  List<SingleEmpLeaveHistoryModel> get singleEmpLeaveList =>
      _singleEmpLeaveList;

  Future<void> getSingleEmployeeLeaveHistory() async {
    var data = await apiService.getData(
        'api/Leave/SingleEmpLeaveHistory?IdCard=${DashboardHelpers.currentUser!.iDnum}');

    if (data != null) {
      _singleEmpLeaveList.clear();
      for (var i in data['Results']) {
        _singleEmpLeaveList.add(SingleEmpLeaveHistoryModel.fromJson(i));
      }
    }
    debugPrint('_singleEmpLeaveList ${_singleEmpLeaveList.length}');
    notifyListeners();
  }

  Future<PayslipModel?> getPaySlipInfo(String month, String year) async {
    setLoading(true);
    var response = await apiService.postData('api/hr/GetPayslip', {
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
    return response == null
        ? null
        : response['Data'].isEmpty
            ? null
            : PayslipModel.fromJson(response['Data'][0]);
  }

  Future<PayslipModel?> getPaySlipInfoWithDetailsBreakdown(
      String month, String year) async {
    setLoading(true);
    var response = await apiService.postData('api/hr/SingleSalRptBreakDown', {
      "Company": 1,
      "DepartmenmtId": 0,
      "SectionId": 0,
      "UnitiD": 0,
      "LineId": 0,
      "DesignationId": 0,
      "SalaryMonth": month,
      "SalaryYear": year,
      "ReportType": 5,
      "CompanyText": "Yunusco (BD) Limited",
      "IdList": DashboardHelpers.currentUser!.iDnum,
      "Grade": 0,
      "DivisionId": 0,
      "IsM": false,
      "UserType": "COM"
    });

    setLoading(false);
    return response == null
        ? null
        : response['Data'].isEmpty
            ? null
            : PayslipModel.fromJson(response['Data'][0]);
  }

  JobCardDropdownModel? allDropdownInfoForJobcard;

  Future<void> getAllDropdownInfoForJobcard() async {
    var data = await apiService.getData('api/HR/SalaryReportDropDown');
    if (data != null) {
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

  Future<void> getAllStuffList() async {
    //
    //StaffEmpData
    var data = await apiService.getData('api/Test/AllEmpData');
    if (data != null) {
      _member_list.clear();
      for (var i in data) {
        _member_list.add(MembersModel.fromJson(i));
      }
    }
    debugPrint('_member_list ${_member_list.length}');
    notifyListeners();
  }

  //
  Future<bool> saveVehicleRequisation(dynamic formData) async {
    setLoading(true);
    var result = await apiService.postData(
        'api/Inventory/SaveVehicleRequisition', formData);
    setLoading(false);
    return result == null ? false : true;
  }

  final List<VehicleModel> _vehicleList = [];

  List<VehicleModel> get vehicleList => _vehicleList;

  Future<void> getRequestedCarList() async {
    setLoading(true);
    var data = await apiService
        .getData('api/inventory/UserWiseVehicleRequisitionList');
    setLoading(false);
    if (data != null) {
      _vehicleList.clear();
      for (var i in data['returnvalue']) {
        _vehicleList.add(VehicleModel.fromJson(i));
      }
    }
    debugPrint('_vehicleList ${_vehicleList.length}');
    notifyListeners();
  }

  Future<bool> acceptVehicleRequisation(dynamic data) async {
    var result =
        await apiService.postData('api/Inventory/RequisitionApproved', data);
    return result == null ? false : true;
  }

  Future<bool> rejectVehicleRequisation(dynamic data) async {
    var result =
        await apiService.postData('api/Inventory/RequisitionReject', data);
    return result == null ? false : true;
  }

  Future<bool> saveDocAppointment(dynamic data) async {
    setLoading(true);
    var result =
        await apiService.postData('api/HR/SaveAccessoriesGatePass', data);
    setLoading(false);
    return result == null ? false : true;
  }

  final List<DocAppoinmentListModel> _docAppointmentList = [];
  List<DocAppoinmentListModel> get docAppointmentList => _docAppointmentList;

  Future<bool> getAllDocAppointment() async {
    setLoading(true);

    try {
      var result = await apiService.getData('api/HR/GatePassList');

      if (result != null) {
        _docAppointmentList.clear();

        // It's good practice to check if 'Results' exists and is a List
        if (result['Results'] is List) {
          for (var i in result['Results']) {
            _docAppointmentList.add(DocAppoinmentListModel.fromJson(i));
          }
        } else {
          // Handle the case where 'Results' is not a list or doesn't exist
          print('Error: "Results" is not a list or is null');
          setLoading(false);
          return false;
        }
      } else {
        // Handle the case where the entire result is null
        setLoading(false);
        return false;
      }

      debugPrint('_docAppointmentList ${_docAppointmentList.length}');

      notifyListeners();
      setLoading(false);
      return true;
    } catch (e) {
      // Handle any errors that occur during the process
      setLoading(false);
      print('Error in getAllDocAppointment: $e');

      // You might want to show an error message to the user here
      // For example: ScaffoldMessenger.of(context).showSnackBar(...);

      return false;
    }
  }

  EmployeeAppointmentInfoModel? _employeeAppointmentInfoModel;
  EmployeeAppointmentInfoModel? get employeeInfo =>
      _employeeAppointmentInfoModel;
  Future<bool> getEmployeeInfo(DocAppoinmentListModel appointment) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var result = await apiService
        .getData('api/HR/GateEmployeeInfo/${appointment.idCardNo}');
    EasyLoading.dismiss();

    for (var i in result['Results']) {
      _employeeAppointmentInfoModel = EmployeeAppointmentInfoModel.fromJson(i);
    }
    notifyListeners();
    return result == null ? false : true;
  }

  final List<MedicineModel> _medicines = [];
  List<MedicineModel> _filteredMedicines = [];

  void getAllMedicine() async {
    var data = await apiService.getData('api/HR/MedicineList');
    if (data != null) {
      _medicines.clear();
      _filteredMedicines.clear();
      for (var i in data['Results']) {
        _medicines.add(MedicineModel.fromJson(i));
      }
    }
    debugPrint('_medicineList ${_medicines.length}');
    _filteredMedicines = List.from(_medicines);
    notifyListeners();
  }

  List<MedicineModel> get medicines => _medicines;
  List<MedicineModel> get filteredMedicines => _filteredMedicines;

  void filterMedicines(String query) {
    if (query.isEmpty) {
      _filteredMedicines = _medicines;
    } else {
      _filteredMedicines = _medicines.where((medicine) {
        return medicine.productName
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ==
                true ||
            medicine.productCode?.toLowerCase().contains(query.toLowerCase()) ==
                true ||
            medicine.baseName?.toLowerCase().contains(query.toLowerCase()) ==
                true;
      }).toList();
    }
    notifyListeners();
  }
//

  final List<PrescriptionMedicine> _prepareMedicineList = [];
  List<PrescriptionMedicine> get prepareMedicineList => _prepareMedicineList;

  void addMedicineListForPrescription(PrescriptionMedicine result) {
    bool found = false;
    // First try to find and update existing medicine
    for (int i = 0; i < _prepareMedicineList.length; i++) {
      if (_prepareMedicineList[i].medicineId == result.medicineId) {
        _prepareMedicineList[i] = result;
        found = true;
        break;
      }
    }
    // If not found, add new medicine
    if (!found) {
      _prepareMedicineList.add(result);
    }
    debugPrint('Added $result');

    notifyListeners(); // If using ChangeNotifier
  }

  void removeMedicine(PrescriptionMedicine e) {
    _prepareMedicineList.remove(e);
    notifyListeners();
  }

  Future<bool> saveGatePassInfo(dynamic data) async {
    setLoading(true);
    var result = await apiService.postData('api/HR/SavePrescription', data);
    //clear medicine list
    _prepareMedicineList.clear();
    setLoading(false);
    return result == null ? false : true;
  }

  bool _showForm = false;
  bool get showForm => _showForm;
  showHideDocForm() {
    _showForm = !_showForm;
    notifyListeners();
  }

  Future<dynamic> gatePassDetailsInfo(
      DocAppoinmentListModel appointment) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var data = await apiService
        .getData('api/HR/GatePassDetails/${appointment.gateId}');
    EasyLoading.dismiss();
    if (data != null) {
      return data['Results'][0];
    } else {
      return null;
    }
  }

  List<Map<String, dynamic>> searchStuffList(String val) {
    final List<Map<String, dynamic>> filterList = [];

    for (var e in _member_list) {
      if (e.idCardNo!.toLowerCase().contains(val.toLowerCase()) ||
          e.fullName!.toLowerCase().contains(val.toLowerCase())) {
        filterList.add({
          "name": e.fullName,
          "id": e.idCardNo,
          "userId":e.userId
        });
      }
    }

    debugPrint('filterList ${filterList.length}');
    return filterList;
  }
}
