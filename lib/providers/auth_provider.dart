import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'package:yunusco_group/utils/constants.dart';
import '../models/user_model.dart';
import '../screens/home_page.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _user != null; // 📌 Load User from Shared Preferences
  Future<void> loadUser() async {
    _user = await DashboardHelpers.getUser();
    notifyListeners();
  }

  List<String> loginModules = [];

  // 📌 Login API Call
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    ApiService apiService = ApiService(); //   "username":"Samin", //       "password":"Abc@#\$02"
    var response = await apiService.postData('api/Accounts/GetUserLogin', {"username": email, "password": password});
    if (response != null) {
      loginModules.clear();
      _user = UserModel.fromJson(response['returnvalue']['login']);
      for (var i in response['returnvalue']['result']) {
        loginModules.add(i['ModuleId'].toString());
      }
      DashboardHelpers.currentUser = _user;
      await DashboardHelpers.saveUser(_user!);
      DashboardHelpers.setToken(response['token'] ?? '');
      _isLoading = false;
      debugPrint('loginModules: $loginModules');
      DashboardHelpers.saveUserModules('roles', loginModules);
      notifyListeners();
      return true;
    } // else {
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await DashboardHelpers.clearUser();
    _user = null;
    AppConstants.token = '';
    notifyListeners();
  }

  void setIsLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  List<Menu> menuList = [];
  Future<void> getMenuList() async {
    final pref = await SharedPreferences.getInstance();
    final roleStrings = pref.getStringList('roles') ?? []; // Convert roles to a Set of ints for faster lookup
    final roleIds = roleStrings.map(int.parse).toSet();
    menuList = fullModuleList.where((e) => roleIds.contains(e.id)).map((e) => Menu(e.id, e.icon, e.title, false)).toList();
    notifyListeners();
  }


}
