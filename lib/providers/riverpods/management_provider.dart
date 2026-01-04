
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/appointment_model.dart';
import 'package:yunusco_group/models/buyer_wise_value_model.dart';
import 'package:yunusco_group/models/production_strength_model.dart';
import 'package:yunusco_group/models/shipment_info_model.dart';
import 'package:yunusco_group/providers/riverpods/purchase_order_riverpod.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'dart:math';
import '../../helper_class/firebase_helpers.dart';
import '../../models/announcement_model.dart';
import '../../models/dhu_model.dart';
import '../../models/item_efficiency_model.dart';
import 'package:intl/intl.dart';

import '../../models/members_model.dart';

ApiService apiService=ApiService();


final dateStateProvider = StateProvider<Map<String, DateTime?>>((ref) {
  return {
    'fromDate': null,
    'toDate': null,
  };
});

final numValueProvider = FutureProvider<num>((ref) async {
  final dates = ref.watch(dateStateProvider);
  final fromDate = dates['fromDate'];
  final toDate = dates['toDate'];
  return await getKaizanValue(fromDate, toDate);
});

Future<dynamic> getKaizanValue(DateTime? fromDate, DateTime? toDate) async {
  ApiService apiService = ApiService();

  if (fromDate == null || toDate == null) {
    var data = await apiService.getData('api/dashboard/KaizanCount');
    return data != null ? data['returnvalue'] : 0.0;
  } else {
    var data = await apiService.getData(
        'api/dashboard/KaizanCount?fromDate=${DashboardHelpers.convertDateTime(fromDate.toString(), pattern: 'dd-MM-yyyy')}&toDate=${DashboardHelpers.convertDateTime(toDate.toString(), pattern: 'dd-MM-yyyy')}'
    );
    return data != null ? data['returnvalue'] : 0.0;
  }
}

final randNum = StateProvider<int>((ref) {
  var secureRandom = Random();
  var data=secureRandom.nextInt(100);
  return data;
});




///announcement providers
///

// providers/news_feed_provider.dart


// Firebase Service Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});






/// nov 5
///



final selectedDateProvider = StateProvider<String>((ref) {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
});

final efficiencyDataProvider = FutureProvider<List<ItemEfficiencyModel>>((ref) async {
  final date = ref.watch(selectedDateProvider);
  return fetchEfficiencyByDate(date);
});

final strengthDataProvider=FutureProvider<List<ProductionStrengthModel>>((ref) async{
  final date = ref.watch(selectedDateProvider);
  return productionStrengthyByDate(date);
});

Future<List<ItemEfficiencyModel>> fetchEfficiencyByDate(String date) async {

  List<ItemEfficiencyModel> jsonList=[];
  var data= await apiService.getData('api/Finishing/ItemWiseEffi?ProductionDate=$date');

  if (data!=null) {
    for(var i in data['Results']){
      jsonList.add(ItemEfficiencyModel.fromJson(i));
    }

    debugPrint('jsonList ${jsonList.length}');

    return jsonList;
  } else {
    throw Exception('Failed to load efficiency data');
  }
}

Future<List<ProductionStrengthModel>> productionStrengthyByDate(String date) async {

  List<ProductionStrengthModel> jsonList=[];
  var data= await apiService.getData('api/Dashboard/ProductionStregnth?date=$date');

  if (data!=null) {
    for(var i in data['returnvalue']){
      jsonList.add(ProductionStrengthModel.fromJson(i));
    }
    debugPrint('production strength ${jsonList.length}');

    return jsonList;
  } else {
    throw Exception('Failed to load efficiency data');
  }
}





// Add these providers to your provider file:
final shipmentFromDateProvider = StateProvider<String>((ref) {
  final now = DateTime.now();
  final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
  return DateFormat('yyyy-MM-dd').format(firstDayOfLastMonth);
});

final shipmentToDateProvider = StateProvider<String>((ref) {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
});

final shipmentInfoProvider = FutureProvider<List<ShipmentInfoModel>>((ref) async {
  final fromDate = ref.watch(shipmentFromDateProvider);
  final toDate = ref.watch(shipmentToDateProvider);
  return getShipmentInfo(fromDate, toDate);
});



Future<List<ShipmentInfoModel>> getShipmentInfo(String formDate,String toDate) async {

  ///api/Dashboard/MonthlyTAndAAnalysis?FromDate=2025-08-01&ToDate=2025-08-31
  List<ShipmentInfoModel> jsonList=[];
  var data= await apiService.getData('api/Dashboard/MonthlyTAndAAnalysis?FromDate=$formDate&ToDate=$toDate');

  if (data!=null) {
    for(var i in data['returnvalue']){
      jsonList.add(ShipmentInfoModel.fromJson(i));
    }
    debugPrint('shipment info ${jsonList.length}');

    return jsonList;
  } else {
    throw Exception('Failed to load efficiency data');
  }
}


final mmrValueProvider=FutureProvider.family((ref,date) async {
  final apiService=ref.watch(apiServiceProvider);
  final data=await apiService.getData('api/Dashboard/GetMMRRatio?date=$date');

  return data;
});


final dhuDataProvider = FutureProvider.family<DHUResponse, String>((ref, date) async {
  final apiService = ref.watch(apiServiceProvider);
  final data = await apiService.getData('api/QMS/GetDHU?qmsDate=$date');

  return DHUResponse.fromJson(data);
});





final allStaffListProvider = FutureProvider.family<List<MembersModel>,String>((ref,id) async {
  final apiService = ref.read(apiServiceProvider);

  final data = await apiService.getData('api/Test/AllEmpData');

  if (data == null) return [];

  List<MembersModel> dataList =
  data.map<MembersModel>((e) => MembersModel.fromJson(e)).toList();

  List<MembersModel> managementList = dataList
      .where((e) => e.departmentName == 'Management')
      .toList();

  debugPrint('managementList ${managementList.length}');
  return managementList;
});


//get all appointment list

final allAppointmentListProvider =
FutureProvider.autoDispose<List<AppointmentModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);

  final data = await apiService.getData('api/Support/appointments');

  if (data == null) return [];

  /// Convert json → model list
  List<AppointmentModel> dataList =
  data['data']
      .map<AppointmentModel>((e) => AppointmentModel.fromJson(e))
      .toList();

  // /// Filter: keep only items whose status is NOT "Completed"
  // List<AppointmentModel> filteredList = dataList
  //     .where((item) => item.status?.toLowerCase() != "completed")
  //     .toList();

  /// Reverse the list to show newest appointments first
  List<AppointmentModel> reversedList = dataList.reversed.toList();

  debugPrint('Filtered appointmentList ${dataList.length}');
  debugPrint('Reversed appointmentList ${reversedList.length}');

  return reversedList;
});


// -------------------- Provider --------------------
final updateProvider = StateProvider<bool>((ref) => false);

// -------------------- Function --------------------
Future<void> createManagementMeeting(WidgetRef ref, Map<String, dynamic> body) async {
  try {
    final apiService = ref.read(apiServiceProvider);

    final response = await apiService.postData('api/support/Appointments', body);

    if (response != null) {
      ref.read(updateProvider.notifier).state = true; // Success
    } else {
      ref.read(updateProvider.notifier).state = false;
      throw Exception('Update failed with status: ${response?.statusCode}');
    }
  } catch (e) {
    ref.read(updateProvider.notifier).state = false;
    print('Update error: $e');
    rethrow;
  }
}

final announcementsProvider = FutureProvider<List<AnnouncementModel>>((ref) async {
  List<AnnouncementModel> announcementList = [];
  final apiService = ref.read(apiServiceProvider);
  final res = await apiService.getData('api/Support/GetAnnouncements');
  if (res != null) {
    for(var i in res['data']){
      announcementList.add(AnnouncementModel.fromJson(i));
    }
  }


  return announcementList;
});

