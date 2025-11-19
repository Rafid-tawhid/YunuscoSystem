// providers/tna_notification_provider.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../models/tna_notification_model.dart';
import '../../service_class/api_services.dart';

// Dummy data provider
final tnaNotificationsProvider = StateNotifierProvider<TnaNotificationNotifier,List<TnaNotificationModel>>((ref){

  return TnaNotificationNotifier();
});



class TnaNotificationNotifier extends StateNotifier<List<TnaNotificationModel>>{
  TnaNotificationNotifier() : super([]);
  ApiService apiService=ApiService();

  Future<void> loadErrorSummaryData(String date) async {
    try {
      List<TnaNotificationModel> dataList=[];
      final data = await apiService.getData('api/Support/GetTNAData');
      for(var i in data['data'])
      {
        dataList.add(TnaNotificationModel.fromJson(i));
      }
      debugPrint('notificationList ${dataList.length}');
      state=dataList;
    } catch (e) {
      state = [];
      rethrow;
    }
  }

}