

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/models/accessories_issuee_model.dart';

import '../../models/accessories_req_details.dart';
import 'employee_provider.dart';

final accessoriesRequisitionProvider = FutureProvider<List<AccessoriesIssueeModel>>((ref) async {

  final service = ref.read(apiServiceProvider);

  final data =
  await service.getData('api/Inventory/InvAccessoriesGoodsIssueMaster');

  List<AccessoriesIssueeModel> accessories = [];

  if (data != null && data['returnvalue'] != null) {
    for (var i in data['returnvalue']) {
      accessories.add(AccessoriesIssueeModel.fromJson(i));
    }
  }
  debugPrint('InvAccessoriesGoodsIssueMaster ${accessories.length}');
  return accessories;
});


final accessoriesReqDetailsListProvider =
FutureProvider.family<List<AccessoriesReqDetails>, String>((ref, id) async {
  final service = ref.read(apiServiceProvider);
  final data = await service.getData('api/Inventory/InvAccessoriesGoodsIssueReport/$id');

  List<AccessoriesReqDetails> accessories = [];
  if (data != null && data['returnvalue'] != null) {
    for (var i in data['returnvalue']) {
      accessories.add(AccessoriesReqDetails.fromJson(i));
    }
  }
  debugPrint('InvAccessoriesGoodsIssueMaster ${accessories.length}');
  return accessories;
});
