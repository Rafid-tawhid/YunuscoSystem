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
  List<NotificationModel> _filterAllNotification = [];

  Future<bool> getAllNotification(String userId) async {
    try {
      setLoading(true);

      // Clear existing notifications before fetching new ones
      _getAllNotification.clear();
      notifyListeners(); // Notify UI to reflect the cleared state immediately

      // Fetch data from API
      final response = await apiService.getData('api/Leave/GetRcntPenLevLst?IdCard=$userId');

      // Early return if no data
      if (response == null || response['Results'] == null) {
        return false;
      }

      // Process and sort notifications in a single operation
      _getAllNotification = (response['Results'] as List).map((json) => NotificationModel.fromJson(json)).toList()..sort((a, b) => (b.leaveId ?? 0).compareTo(a.leaveId ?? 0));

      debugPrint('Fetched ${_getAllNotification.length} notifications');
      _filterAllNotification.addAll(_getAllNotification);
      return true;
    } catch (e, stackTrace) {
      debugPrint('Error fetching notifications: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> acceptLeaveApproval(dynamic data) async {
    await apiService.postData('api/Leave/ApproveLeave', data);
  }

  void getFilterNotification(int deptId) {
    debugPrint('deptId ${deptId}');
    _getAllNotification.clear();
    _getAllNotification.addAll(deptId == 0 ? _filterAllNotification : _filterAllNotification.where((e) => e.departmentId == deptId).toList());
    notifyListeners();
  }
}
