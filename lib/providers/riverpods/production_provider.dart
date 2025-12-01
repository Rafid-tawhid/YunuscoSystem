// simple_providers.dart

// Provider for Production QC Data
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/models/error_summery_model.dart';
import 'package:yunusco_group/models/qc_pass_summary_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../../models/mis_asset_model.dart';
import '../../models/production_qc_model.dart';
import '../../models/qc_difference_model.dart';
import 'employee_provider.dart';

final qcDataProvider =
    StateNotifierProvider<QcDataNotifier, List<ProductionQcModel>>((ref) {
  return QcDataNotifier();
});

class QcDataNotifier extends StateNotifier<List<ProductionQcModel>> {
  QcDataNotifier() : super([]);

  ApiService apiService = ApiService();

  Future<void> loadQcData(String date) async {
    debugPrint('Selected date :$date');
    try {
      List<ProductionQcModel> qcList = [];
      final data = await apiService
          .getData('api/Support/GetQCPassDataByDate?selectedDate=$date');
      for (var i in data['data']) {
        qcList.add(ProductionQcModel.fromJson(i));
      }
      state = qcList;
    } catch (e) {
      state = []; // Clear on error, or handle differently
      rethrow;
    }
  }
}

// Provider for QC Difference Data
final differenceDataProvider =
    StateNotifierProvider<DifferenceDataNotifier, List<QcDifferenceModel>>(
        (ref) {
  return DifferenceDataNotifier();
});

class DifferenceDataNotifier extends StateNotifier<List<QcDifferenceModel>> {
  DifferenceDataNotifier() : super([]);
  ApiService apiService = ApiService();

  Future<void> loadDifferenceData(String date1, String date2) async {
    try {
      List<QcDifferenceModel> diffList = [];
      final data = await apiService.getData(
          'api/Support/GetQCPassComparisonByDate?startDate=$date1&endDate=$date2');
      for (var i in data['data']) {
        diffList.add(QcDifferenceModel.fromJson(i));
      }
      state = diffList;
    } catch (e) {
      state = [];
      rethrow;
    }
  }
}

final summaryDataProvider =
    StateNotifierProvider<QcPassSummaryNotifier, List<QcPassSummaryModel>>(
        (ref) {
  return QcPassSummaryNotifier();
});

class QcPassSummaryNotifier extends StateNotifier<List<QcPassSummaryModel>> {
  QcPassSummaryNotifier() : super([]);
  ApiService apiService = ApiService();

  Future<void> loadSummaryData(String date1, String date2) async {
    try {
      List<QcPassSummaryModel> summaryList = [];
      final data = await apiService.getData(
          'api/Support/GetQCPassSummaryByDateRange?startDate=$date1&endDate=$date2');
      for (var i in data['data']) {
        summaryList.add(QcPassSummaryModel.fromJson(i));
      }
      state = summaryList;
    } catch (e) {
      state = [];
      rethrow;
    }
  }
}

// Simple loading state provider
final loadingProvider = StateProvider<bool>((ref) => false);

final errorSummaryProvider =
    StateNotifierProvider<ErrorSummaryNotifier, List<ErrorSummaryModel>>((ref) {
  return ErrorSummaryNotifier();
});

// Provider for selected date
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

class ErrorSummaryNotifier extends StateNotifier<List<ErrorSummaryModel>> {
  ErrorSummaryNotifier() : super([]);
  ApiService apiService = ApiService();

  Future<void> loadErrorSummaryData(String date) async {
    try {
      List<ErrorSummaryModel> summaryList = [];
      final data = await apiService.getData(
          'api/Support/GetDailyErrorSummary?startDate=$date&endDate=$date');
      for (var i in data['data']) {
        summaryList.add(ErrorSummaryModel.fromJson(i));
      }

      debugPrint('errorList ${summaryList.length}');
      state = summaryList;
    } catch (e) {
      state = [];
      rethrow;
    }
  }

  int get totalDefects {
    return state.fold(
        0, (sum, item) => sum + (item.totalDefects?.toInt() ?? 0));
  }

  // Get unique error types count
  int get uniqueErrorTypes {
    return state.map((e) => e.errorName).toSet().length;
  }
}

//rafid nov 29

// Separate provider for all MIS assets
final allMisAssetsProvider = FutureProvider<List<MisAssetModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService
      .getData('api/Support/getAllMisAssets'); // Adjust endpoint as needed

  if (response != null) {
    List<MisAssetModel> assets = [];
    for (var item in response['data']) {
      assets.add(MisAssetModel.fromJson(item));
    }
    return assets;
  } else {
    throw Exception('Failed to load MIS assets');
  }
});

// Search Query Provider
final misAssetSearchQueryProvider = StateProvider<String>((ref) => '');

// Filtered MIS Assets Provider
final filteredMisAssetsProvider = Provider<List<MisAssetModel>>((ref) {
  final searchQuery = ref.watch(misAssetSearchQueryProvider);
  final assetsAsync = ref.watch(allMisAssetsProvider);


  return assetsAsync.when(
    data: (assets) {
      if (searchQuery.isEmpty) return assets;

      final query = searchQuery.toLowerCase();
      return assets.where((asset) {
        return asset.employeeName?.toLowerCase().contains(query) == true ||
            asset.employeeIdcardNo?.toLowerCase().contains(query) == true ||
            asset.assetNo?.toLowerCase().contains(query) == true;
      }).toList();
    },
    loading: () => [],
    error: (error, stack) => [],
  );
});

// Additional utility function to get filtered data for testing
List<MisAssetModel> getFilteredMisAssets(
    List<MisAssetModel> assets, String query) {
  if (query.isEmpty) return assets;

  final lowerQuery = query.toLowerCase();
  return assets.where((asset) {
    return asset.employeeName?.toLowerCase().contains(lowerQuery) == true ||
        asset.employeeIdcardNo?.toLowerCase().contains(lowerQuery) == true ||
        asset.assetNo?.toLowerCase().contains(lowerQuery) == true;
  }).toList();
}
