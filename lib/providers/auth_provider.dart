import 'dart:convert';import 'package:flutter/material.dart';import 'package:http/http.dart' as http;import 'package:yunusco_group/helper_class/dashboard_helpers.dart';import 'package:yunusco_group/service_class/api_services.dart';import 'package:yunusco_group/utils/constants.dart';import '../models/user_model.dart';class AuthProvider with ChangeNotifier {  UserModel? _user;  bool _isLoading = false;  //  UserModel? get user => _user;  bool get isLoading => _isLoading;  bool get isAuthenticated => _user != null;  // 📌 Load User from Shared Preferences  Future<void> loadUser() async {    _user = await DashboardHelpers.getUser();    notifyListeners();  }  // 📌 Login API Call  Future<bool> login(String email, String password) async {    _isLoading = true;    notifyListeners();    ApiService apiService=ApiService();    var response=await apiService.postData(AppConstants.loginUrl,{      "username":"sewing",      "password":"Dhaka@121"    });    if(response!=null){      _user = UserModel.fromJson(response['returnvalue']['login']);      await DashboardHelpers.saveUser(_user!);      _isLoading = false;      notifyListeners();      return true;    }    else {      _isLoading = false;      notifyListeners();      return false;    }  }  // 📌 Logout  Future<void> logout() async {    await DashboardHelpers.clearUser();    _user = null;    notifyListeners();  }  void setIsLoading(bool val) {    _isLoading=val;    notifyListeners();  }}