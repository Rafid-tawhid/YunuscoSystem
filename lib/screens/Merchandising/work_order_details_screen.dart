import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderData {
  final List<dynamic> actual;
  final List<dynamic> extra;
  final List<dynamic> sample;
  final List<dynamic> total;

  OrderData({
    required this.actual,
    required this.extra,
    required this.sample,
    required this.total,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      actual: json['Actual'],
      extra: json['Extra'],
      sample: json['Sample'],
      total: json['Total'],
    );
  }

  num get totalActualQuantity {
    return actual.fold(0, (sum, item) => sum + (item['Total'] ?? item['TotalQuantity'] ?? 0));
  }

  num get totalExtraQuantity {
    return extra.fold(0, (sum, item) => sum + (item['Total'] ?? item['TotalQuantity'] ?? 0));
  }

  num get totalSampleQuantity {
    return sample.fold(0, (sum, item) => sum + (item['TotalQuantity'] ?? 0));
  }
}





class OrderSummaryScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderSummaryScreen({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {

    final data = OrderData.fromJson(orderData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryCards(data),
            const SizedBox(height: 24),
            _buildSectionTitle('Actual Production'),
            _buildProductionTable(data.actual),
            const SizedBox(height: 24),
            _buildSectionTitle('Samples'),
            _buildSamplesTable(data.sample),
            const SizedBox(height: 24),
            _buildOrderDetails(data.actual.isNotEmpty ? data.actual[0] : null),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(OrderData data) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            value: data.totalActualQuantity.toInt(),
            label: 'Total Units (Actual)',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            value: data.totalExtraQuantity.toInt(),
            label: 'Extra Units',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            value: data.totalSampleQuantity.toInt(),
            label: 'Samples',
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductionTable(List<dynamic> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Style')),
          DataColumn(label: Text('Color')),
          DataColumn(label: Text('XS'), numeric: true),
          DataColumn(label: Text('S'), numeric: true),
          DataColumn(label: Text('M'), numeric: true),
          DataColumn(label: Text('L'), numeric: true),
          DataColumn(label: Text('XL'), numeric: true),
          DataColumn(label: Text('XXL'), numeric: true),
          DataColumn(label: Text('Total'), numeric: true),
        ],
        rows: items.map((item) => _buildProductionRow(item)).toList(),
      ),
    );
  }

  DataRow _buildProductionRow(dynamic item) {
    final total = item['Total'] ?? 0;
    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
            (states) => total == 0 ? Colors.grey[100] : null,
      ),
      cells: [
        DataCell(Text(item['StyleNumber'] ?? item['StyleRef'] ?? '')),
        DataCell(Text(item['Color'] ?? '')),
        DataCell(Text((item['S22_XS'] ?? 0).toString())),
        DataCell(Text((item['S19_S'] ?? 0).toString())),
        DataCell(Text((item['S20_M'] ?? 0).toString())),
        DataCell(Text((item['S21_L'] ?? 0).toString())),
        DataCell(Text((item['S23_XL'] ?? 0).toString())),
        DataCell(Text((item['S71_XXL'] ?? 0).toString())),
        DataCell(
          Text(
            total.toString(),
            style: TextStyle(
              color: total > 0 ? Colors.blue : Colors.grey,
              fontWeight: total > 0 ? FontWeight.bold : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSamplesTable(List<dynamic> samples) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Color')),
        DataColumn(label: Text('Size M'), numeric: true),
        DataColumn(label: Text('Total'), numeric: true),
      ],
      rows: samples.map((sample) => DataRow(
        cells: [
          DataCell(Text(sample['Color'] ?? '')),
          DataCell(Text((sample['S20_M'] ?? 0).toString())),
          DataCell(Text((sample['TotalQuantity'] ?? 0).toString())),
        ],
      )).toList(),
    );
  }

  Widget _buildOrderDetails(dynamic item) {
    if (item == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text('Buyer PO: ${item['BuyerPO'] ?? ''}'),
        Text('Country: ${item['Country'] ?? ''}'),
        if (item['Tod'] != null)
          Text('Target Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(item['Tod']))}'),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}