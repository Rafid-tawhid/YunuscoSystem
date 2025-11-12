import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/models/members_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';

final staffProvider =StateNotifierProvider<StaffNotifier,List<MembersModel>>((ref){

  return StaffNotifier();
});

class StaffNotifier extends StateNotifier<List<MembersModel>> {
  StaffNotifier():super([]);
  
  Future<void> getAllStaffList() async {
    var data=await ApiService().getData('api/Test/AllEmpData');
    if (data != null) {
      state = [];
      for (var i in data) {
        state.add(MembersModel.fromJson(i));
      }
    }
    debugPrint('staffList ${state.length}');
  }
}