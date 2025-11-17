// simple_providers.dart


// Provider for Production QC Data
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../../models/production_qc_model.dart';
import '../../models/qc_difference_model.dart';

final qcDataProvider = StateNotifierProvider<QcDataNotifier, List<ProductionQcModel>>((ref) {
  return QcDataNotifier();
});

class QcDataNotifier extends StateNotifier<List<ProductionQcModel>> {
  QcDataNotifier() : super([]);

  ApiService apiService=ApiService();

  Future<void> loadQcData(String date) async {
    debugPrint('Selected date :$date');
    try {
      List<ProductionQcModel> qcList=[];
      final data = await apiService.getData('api/Support/GetQCPassDataByDate?selectedDate=2025-11-13');
      for(var i in data['data'])
      {
        qcList.add(ProductionQcModel.fromJson(i));
      }
      state=qcList;
    } catch (e) {
      state = []; // Clear on error, or handle differently
      rethrow;
    }
  }
}

// Provider for QC Difference Data
final differenceDataProvider = StateNotifierProvider<DifferenceDataNotifier, List<QcDifferenceModel>>((ref) {
  return DifferenceDataNotifier();
});

class DifferenceDataNotifier extends StateNotifier<List<QcDifferenceModel>> {
  DifferenceDataNotifier() : super([]);
  ApiService apiService=ApiService();

  Future<void> loadDifferenceData(String date1, String date2) async {
    try {
      List<QcDifferenceModel> diffList=[];
      final data = await apiService.getData('api/Support/GetQCPassComparisonByDate?startDate=2025-11-10&endDate=2025-11-11');
      for(var i in data['data'])
      {
        diffList.add(QcDifferenceModel.fromJson(i));
      }
      state=diffList;
    } catch (e) {
      state = [];
      rethrow;
    }
  }
}

// Simple loading state provider
final loadingProvider = StateProvider<bool>((ref) => false);