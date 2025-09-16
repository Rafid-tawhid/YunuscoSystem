// import 'package:flutter/cupertino.dart';
// import 'package:yunusco_group/service_class/api_services.dart';
//
// import '../models/line_setup_model.dart';
//
// class PlanningProvider extends ChangeNotifier {
//   ApiService apiService = ApiService();
//
//   final List<LineSetupModel> _allPlanningList = [];
//   List<LineSetupModel> get allPlanningList => _allPlanningList;
//
//   Future<bool> getAllPlanningList(String date) async {
//     var data = await apiService
//         .getData('api/Manufacturing/TargetLineSetup?date=$date');
//     if (data != null) {
//       _allPlanningList.clear();
//       for (var i in data['returnvalue']) {
//         _allPlanningList.add(LineSetupModel.fromJson(i));
//       }
//       notifyListeners();
//       debugPrint('_allPlanningList ${_allPlanningList.length}');
//       return true;
//     } else {
//       return false;
//     }
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import '../../helper_class/dashboard_helpers.dart';
import '../../models/line_setup_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers.dart
// Add this provider to track retries

// StateProvider for selected date
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// StateProvider for search query
final searchQueryProvider = StateProvider<String>((ref) => "");

// Remove autoDispose to prevent multiple API calls
final planningProvider = FutureProvider.family<List<LineSetupModel>, DateTime>((ref, date) async {
  try {
    final formattedDate = DashboardHelpers.convertDateTime2(date);
    final response = await ApiService().getDataNew('api/Manufacturing/TargetLineSetup?date=$formattedDate');

    if (response == null) {
      throw Exception('No response from server');
    }

    if (response['returnvalue'] == null) {
      throw Exception('Invalid data format from server');
    }

    final List<dynamic> data = response['returnvalue'];
    return data.map((item) => LineSetupModel.fromJson(item)).toList();
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
});
