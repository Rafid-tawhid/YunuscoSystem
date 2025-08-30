import 'package:flutter/cupertino.dart';

class StylewiseEfficiencyModel {
  final String sectionName;
  final String lineName;
  final String buyerName;
  final String styleNo;
  final int po;
  final String item;
  final Map<DateTime, double?> dateEfficiencies;

  StylewiseEfficiencyModel({
    required this.sectionName,
    required this.lineName,
    required this.buyerName,
    required this.styleNo,
    required this.po,
    required this.item,
    required this.dateEfficiencies,
  });

  factory StylewiseEfficiencyModel.fromJson(Map<String, dynamic> json) {
    // Parse date efficiencies
    final dateEfficiencies = <DateTime, double?>{};
    if (json['DateEfficiencies'] != null) {
      (json['DateEfficiencies'] as Map<String, dynamic>)
          .forEach((dateStr, value) {
        try {
          final date = DateTime.parse(dateStr);
          dateEfficiencies[date] = value?.toDouble();
        } catch (e) {
          // Handle invalid date strings if needed
          debugPrint('Error parsing date $dateStr: $e');
        }
      });
    }

    return StylewiseEfficiencyModel(
      sectionName: json['SectionName'] ?? '',
      lineName: json['LineName'] ?? '',
      buyerName: json['BuyerName'] ?? '',
      styleNo: json['StyleNo'] ?? '',
      po: json['PO'] ?? 0,
      item: json['Item'] ?? '',
      dateEfficiencies: dateEfficiencies,
    );
  }

  Map<String, dynamic> toJson() {
    // Convert DateTime keys back to formatted strings
    final dateEfficienciesJson = <String, dynamic>{};
    dateEfficiencies.forEach((date, value) {
      dateEfficienciesJson[_formatDate(date)] = value;
    });

    return {
      'SectionName': sectionName,
      'LineName': lineName,
      'BuyerName': buyerName,
      'StyleNo': styleNo,
      'PO': po,
      'Item': item,
      'DateEfficiencies': dateEfficienciesJson,
    };
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'StylewiseEfficiencyModel{sectionName: $sectionName, lineName: $lineName, buyerName: $buyerName, styleNo: $styleNo, po: $po, item: $item, dateEfficiencies: $dateEfficiencies}';
  }
}
