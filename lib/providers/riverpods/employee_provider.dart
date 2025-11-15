import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/models/attendance_board_model.dart';
import 'package:yunusco_group/models/emp_single_evaluation_model.dart';
import 'package:yunusco_group/models/members_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';
// providers/performance_rating_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/emp_performance_rating_model.dart';

final staffProvider =StateNotifierProvider<StaffNotifier,List<MembersModel>>((ref){

  return StaffNotifier();
});

class StaffNotifier extends StateNotifier<List<MembersModel>> {
  StaffNotifier():super([]);
  
  Future<void> getAllStaffList() async {
    var data=await ApiService().getData('api/Test/AllEmpData');
    if (data != null) {
      state = [];
      for (var i in data) {
        state.add(MembersModel.fromJson(i));
      }
    }
    debugPrint('staffList ${state.length}');
  }
}






// API Service Provider
final performanceRatingApiProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// State Notifier
class PerformanceRatingNotifier extends StateNotifier<AsyncValue<List<EmpPerformanceRatingModel>>> {
  final ApiService _apiService;

  PerformanceRatingNotifier(this._apiService) : super(const AsyncValue.loading());

  Future<void> fetchPerformanceRatings() async {
    state = const AsyncValue.loading();
    try {
      final results = await _apiService.getData('api/Support/GetEmployeePerformanceSummary');
      List<EmpPerformanceRatingModel> ratings=[];
      for(var i in results){
        ratings.add(EmpPerformanceRatingModel.fromJson(i));
      }

      state = AsyncValue.data(ratings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    return fetchPerformanceRatings();
  }
}

// State Notifier Provider
final performanceRatingProvider = StateNotifierProvider<PerformanceRatingNotifier, AsyncValue<List<EmpPerformanceRatingModel>>>((ref) {
  final apiService = ref.watch(performanceRatingApiProvider);
  return PerformanceRatingNotifier(apiService);
});


//state notifier
class EmployeeSingleNotifier extends StateNotifier<AsyncValue<List<EmpSingleEvaluationModel>>>{
  final ApiService apiService;
  EmployeeSingleNotifier(this.apiService):super(const AsyncValue.data([]));

  Future<void> getSingleValue(String idCardNo) async {
    state=const AsyncValue.loading();
    try {
      final result=await apiService.getData('api/Support/GetEmpPerformanceInfoById?idCardNo=$idCardNo');
      if(result!=null){
        final List<EmpSingleEvaluationModel> dataList=[];
        for(var i in result['data']) {
          dataList.add(EmpSingleEvaluationModel.fromJson(i));
        }
        state=AsyncValue.data(dataList);
      }

    }
    catch(e,st){
      state=AsyncValue.error(e, st);
    }
  }
}
final apiServiceProvider=Provider((ref)=>ApiService());

final employerSingleEvaluationList=StateNotifierProvider<EmployeeSingleNotifier,AsyncValue<List<EmpSingleEvaluationModel>>>((ref){
  final service=ref.read(apiServiceProvider);
  return EmployeeSingleNotifier(service);
});




//attendance board

final userListProvider = StateNotifierProvider<AttendanceListNotifier, List<AttendanceBoardModel>>(
      (ref) => AttendanceListNotifier(ref),
);

class AttendanceListNotifier extends StateNotifier<List<AttendanceBoardModel>> {
  final Ref ref;
  List<AttendanceBoardModel> _originalList = []; // Store original data

  AttendanceListNotifier(this.ref) : super([]);

  Future<void> getEmployeeAttendance(String startDate,String endDate) async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final results = await apiService.getData('api/Support/GetEmployeeAttendanceByDateRange?startDate=$startDate&endDate=$endDate');

      List<AttendanceBoardModel> empList = [];
      for(var i in results['data']) {
        empList.add(AttendanceBoardModel.fromJson(i));
      }

      _originalList = empList; // Store original data
      state = empList; // Replace the entire list with new data

      debugPrint('empList ${empList.length}');
    } catch (e) {
      print('Error fetching employees: $e');
    }
  }

  // Search by ID or Name
  void searchEmployees(String query) {
    if (query.isEmpty) {
      // If search query is empty, show all data
      state = _originalList;
    } else {
      // Filter by ID or Name (case insensitive)
      final filteredList = _originalList.where((employee) {
        final id = employee.employeeId.toString().toLowerCase() ?? '';
        final name = employee.employeeName?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();

        return id.contains(searchQuery) || name.contains(searchQuery);
      }).toList();

      state = filteredList;
    }
  }

  // Clear search and show all data
  void clearSearch() {
    state = _originalList;
  }
}

// Provider for loading state
final isLoadingProvider = StateProvider<bool>((ref) => false);