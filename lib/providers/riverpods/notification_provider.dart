// providers/tna_notification_provider.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../common_widgets/version_control_widgets.dart';
import '../../models/app_version.dart';
import '../../models/tna_notification_model.dart';
import '../../service_class/api_services.dart';
import 'employee_provider.dart';

// Dummy data provider
final tnaNotificationsProvider = StateNotifierProvider<TnaNotificationNotifier,List<TnaNotificationModel>>((ref){

  return TnaNotificationNotifier();
});



class TnaNotificationNotifier extends StateNotifier<List<TnaNotificationModel>>{
  TnaNotificationNotifier() : super([]);
  ApiService apiService=ApiService();

  Future<void> loadNotificationData() async {

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


  Future<void> sendNotification() async {

    try {
      final data = await apiService.postData('api/support/SendTNA_Notification',{});
      debugPrint('sendNotification $data');

    } catch (e) {
      debugPrint('sendNotification ERROR $e');
      state = [];
      rethrow;
    }
  }

}


///AppVersion
// Provider for user data
final versionCheckProvider = FutureProvider<List<AppVersion>>((ref) async {
  List<AppVersion> versionList=[];
  final apiService = ref.watch(apiServiceProvider);

  // Call API to fetch data
  var data= await apiService.getData('api/Production/GetAppVersions');

  if (data != null) {
    for (var i in data) {
      versionList.add(AppVersion.fromJson(i));
    }
  }
  final List<AppVersion> thisAppVersion=versionList.where((e)=>(e.appId=='yunusco.erp.system')).toList();
  debugPrint('thisAppVersion ${thisAppVersion.length}');
  return thisAppVersion;

});


// Simple check for new build
final newBuildProvider = FutureProvider<bool>((ref) async {
  final versions = await ref.watch(versionCheckProvider.future);
  final checker = VersionChecker();
  var info=await checker.hasNewBuild(versions);
  debugPrint('hasNewBuild $info');
  return await checker.hasNewBuild(versions);
});