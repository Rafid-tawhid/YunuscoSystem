import 'package:flutter/widgets.dart';
import 'package:yunusco_group/models/notification_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';

class NotificationProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  int notificationCount = 0;
  bool get isLoading => _isLoading;
  bool _isLoading = false;

  setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  addCount() {
    notificationCount = notificationCount + 1;
    debugPrint('Count is increasing $notificationCount');
    notifyListeners();
  }

  List<NotificationModel> _getAllNotification = [];
  List<NotificationModel> get allNotification => _getAllNotification;
  // List<NotificationModel> _filterAllNotification = [];

  Future<bool> getAllNotification(String userId) async {
    try {
      setLoading(true);
      notifyListeners(); // Notify immediately when loading starts

      // Create a new list instead of clearing to ensure reference changes
      final List<NotificationModel> tempList = [];

      final response =
          await apiService.getData('api/Leave/GetRcntPenLevLst?IdCard=$userId');

      if (response == null || response['Results'] == null) {
        _getAllNotification = []; // Assign empty list
        notifyListeners();
        return false;
      }

      tempList.addAll((response['Results'] as List)
          .map((json) => NotificationModel.fromJson(json)));

      tempList.sort((a, b) => (b.leaveId ?? 0).compareTo(a.leaveId ?? 0));

      // Assign the new list (reference changes will trigger rebuild)
      _getAllNotification = tempList;
      debugPrint('Fetched ${_getAllNotification.length} notifications');

      notifyListeners(); // Notify after data is ready
      return true;
    } catch (e, stackTrace) {
      debugPrint('Error fetching notifications: $e');
      debugPrint('Stack trace: $stackTrace');
      _getAllNotification = []; // Clear on error
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
      // Don't need notify here as we're already notifying at key points
    }
  }

  Future<void> acceptLeaveApproval(dynamic data) async {
    await apiService.postData('api/Leave/ApproveLeave', data);
  }

  void getFilterNotification(int deptId) {
    // debugPrint('deptId ${deptId}');
    // _getAllNotification.clear();
    // _getAllNotification.addAll(deptId == 0 ? _filterAllNotification : _filterAllNotification.where((e) => e.departmentId == deptId).toList());
    // notifyListeners();
  }
}
