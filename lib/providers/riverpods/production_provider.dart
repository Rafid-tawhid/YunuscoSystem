// simple_providers.dart

// Provider for Production QC Data
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/models/error_summery_model.dart';
import 'package:yunusco_group/models/qc_pass_summary_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../../models/machine_breakdown_dropdown.dart';
import '../../models/machine_breakdown_model.dart';
import '../../models/mis_asset_model.dart';
import '../../models/production_qc_model.dart';
import '../../models/qc_difference_model.dart';
import 'employee_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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


// providers/machine_report_provider.dart



////

final machineDropdownDataProvider = FutureProvider<MachineBreakdownDropdown>((ref) async {
  try {
    final apiService = ref.read(apiServiceProvider);
    final response = await apiService.getData('api/Production/GetMaintenanceDropdowns');

    if (response != null && response['Data'] != null) {
      return MachineBreakdownDropdown.fromJson(response['Data']);
    } else {
      throw Exception('No data received from server');
    }
  } catch (e, stackTrace) {
    debugPrint('Dropdown data error: $e');
    debugPrint('Stack trace: $stackTrace');
    throw Exception('Failed to load dropdown data: ${e.toString()}');
  }
});


// dec 4

final submitMachineReportProvider = Provider<Future<dynamic> Function(Map<String, dynamic>)>((ref) {
  final apiService = ref.read(apiServiceProvider);

  return (Map<String, dynamic> reportData) async {
    try {
      final response = await apiService.postData(
          'api/Production/UpdateMachineBreakdown',
          reportData
      );

      if (response != null) {
        return response;
      } else {
        throw Exception('No response from server');
      }
    } catch (e, stackTrace) {
      debugPrint('Submit report error: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to submit report: ${e.toString()}');
    }
  };
});



// dec 4


final machineBreakdownListProvider = FutureProvider<List<MachineBreakdownModel>>((ref) async {
  try {
    final apiService = ref.read(apiServiceProvider);
    final response = await apiService.getData('api/Production/GetAllMachineBreakdown');

    if (response != null) {
      List<MachineBreakdownModel> dataList = [];
      for(var i in response){
        dataList.add(MachineBreakdownModel.fromJson(i));
      }
      return dataList;
    } else {
      throw Exception('No data received from server');
    }
  } catch (e, stackTrace) {
    debugPrint('Machine breakdown list error: $e');
    debugPrint('Stack trace: $stackTrace');
    throw Exception('Failed to load machine breakdowns: ${e.toString()}');
  }
});


// Provider for search/filter functionality
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredBreakdownsProvider = Provider<List<MachineBreakdownModel>>((ref) {
  final breakdownsAsync = ref.watch(machineBreakdownListProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return breakdownsAsync.when(
    data: (breakdowns) {
      if (searchQuery.isEmpty) {
        return breakdowns;
      }

      final query = searchQuery.toLowerCase();
      return breakdowns.where((breakdown) {
        return breakdown.maintenanceName?.toLowerCase().contains(query) == true ||
            breakdown.operationName?.toLowerCase().contains(query) == true ||
            breakdown.lineName?.toLowerCase().contains(query) == true ||
            breakdown.machineType?.toLowerCase().contains(query) == true ||
            breakdown.fullName?.toLowerCase().contains(query) == true ||
            breakdown.taskCode?.toLowerCase().contains(query) == true ||
            breakdown.status?.toLowerCase().contains(query) == true;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider for sorting
enum SortOption { newestFirst, oldestFirst, byStatus, byMachine }

final sortProvider = StateProvider<SortOption>((ref) => SortOption.newestFirst);

final sortedBreakdownsProvider = Provider<List<MachineBreakdownModel>>((ref) {
  final filteredBreakdowns = ref.watch(filteredBreakdownsProvider);
  final sortOption = ref.watch(sortProvider);

  List<MachineBreakdownModel> sortedList = List.from(filteredBreakdowns);

  switch (sortOption) {
    case SortOption.newestFirst:
      sortedList.sort((a, b) {
        final dateA = DateTime.tryParse(a.createdDate ?? '');
        final dateB = DateTime.tryParse(b.createdDate ?? '');
        if (dateA == null || dateB == null) return 0;
        return dateB.compareTo(dateA);
      });
      break;
    case SortOption.oldestFirst:
      sortedList.sort((a, b) {
        final dateA = DateTime.tryParse(a.createdDate ?? '');
        final dateB = DateTime.tryParse(b.createdDate ?? '');
        if (dateA == null || dateB == null) return 0;
        return dateA.compareTo(dateB);
      });
      break;
    case SortOption.byStatus:
      sortedList.sort((a, b) => (a.status ?? '').compareTo(b.status ?? ''));
      break;
    case SortOption.byMachine:
      sortedList.sort((a, b) => (a.machineType ?? '').compareTo(b.machineType ?? ''));
      break;
  }

  return sortedList;
});


//submitMachineRepair

final submitMachineRepair = Provider<Future<dynamic> Function(Map<String, dynamic>)>((ref) {
  final apiService = ref.read(apiServiceProvider);

  return (Map<String, dynamic> data) async {
    try {
      final response = await apiService.postData(
          'api/Production/AddMachineBreakdown',
          data
      );

      if (response != null) {
        return response;
      } else {
        throw Exception('No response from server');
      }
    } catch (e, stackTrace) {
      debugPrint('Submit report error: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to submit report: ${e.toString()}');
    }
  };
});

