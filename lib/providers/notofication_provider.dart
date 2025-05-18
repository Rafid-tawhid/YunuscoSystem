import 'package:flutter/widgets.dart';
import 'package:yunusco_group/models/notification_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';

class NotificationProvider extends ChangeNotifier {
  ApiService apiService=ApiService();
  int notificationCount=0;
  bool get isLoading=>_isLoading;
  bool _isLoading=false;

  setLoading(bool val){
    _isLoading=val;
    notifyListeners();
  }

  addCount(){
    notificationCount=notificationCount+1;
    debugPrint('Count is increasing $notificationCount');
    notifyListeners();
  }

  List<NotificationModel> _getAllNotification=[];
  List<NotificationModel> get allNotification=>_getAllNotification;

  Future<bool> getAllNotification(String userId) async{
    try {
      setLoading(true);
      var data = await apiService.getData('api/Leave/GetRcntPenLevLst?IdCard=${userId}');
      if(data != null) {
        _getAllNotification.clear();
        for(var i in data['Results']){
          _getAllNotification.add(NotificationModel.fromJson(i));
        }
        debugPrint('_getAllNotification ${_getAllNotification.length}');
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      setLoading(false);
      debugPrint('Error fetching costing approval list: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }
}