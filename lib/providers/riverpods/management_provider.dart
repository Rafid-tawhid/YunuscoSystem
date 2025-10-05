
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'dart:math';

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
