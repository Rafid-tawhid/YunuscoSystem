import 'package:flutter/material.dart';

import 'dart:convert';

class Product {
  final String styleName;
  final String styleNumber;
  final String buyerPO;
  final String tod;
  final String country;
  final String color;
  final int s21_L;
  final int s20_M;
  final int s19_S;
  final int s23_XL;
  final int s22_XS;
  final int s71_XXL;
  final int total;

  Product({
    required this.styleName,
    required this.styleNumber,
    required this.buyerPO,
    required this.tod,
    required this.country,
    required this.color,
    required this.s21_L,
    required this.s20_M,
    required this.s19_S,
    required this.s23_XL,
    required this.s22_XS,
    required this.s71_XXL,
    required this.total,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      styleName: json['StyleName'] ?? '',
      styleNumber: json['StyleNumber'] ?? '',
      buyerPO: json['BuyerPO'] ?? '',
      tod: json['Tod'] ?? '',
      country: json['Country'] ?? '',
      color: json['Color'] ?? '',
      s21_L: json['S21_L'] ?? 0,
      s20_M: json['S20_M'] ?? 0,
      s19_S: json['S19_S'] ?? 0,
      s23_XL: json['S23_XL'] ?? 0,
      s22_XS: json['S22_XS'] ?? 0,
      s71_XXL: json['S71_XXL'] ?? 0,
      total: json['Total'] ?? 0,
    );
  }
}

class Extra {
  final String styleName;
  final String styleRef;
  final String buyerPO;
  final String tod;
  final String country;
  final String color;
  final int s21_L;
  final int s20_M;
  final int s19_S;
  final int s23_XL;
  final int s22_XS;
  final int s71_XXL;
  final int total;

  Extra({
    required this.styleName,
    required this.styleRef,
    required this.buyerPO,
    required this.tod,
    required this.country,
    required this.color,
    required this.s21_L,
    required this.s20_M,
    required this.s19_S,
    required this.s23_XL,
    required this.s22_XS,
    required this.s71_XXL,
    required this.total,
  });

  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(
      styleName: json['StyleName'] ?? '',
      styleRef: json['StyleRef'] ?? '',
      buyerPO: json['BuyerPO'] ?? '',
      tod: json['Tod'] ?? '',
      country: json['Country'] ?? '',
      color: json['Color'] ?? '',
      s21_L: json['S21_L'] ?? 0,
      s20_M: json['S20_M'] ?? 0,
      s19_S: json['S19_S'] ?? 0,
      s23_XL: json['S23_XL'] ?? 0,
      s22_XS: json['S22_XS'] ?? 0,
      s71_XXL: json['S71_XXL'] ?? 0,
      total: json['Total'] ?? 0,
    );
  }
}

class Total {
  final String styleName;
  final String styleRef;
  final String buyerPO;
  final String tod;
  final String country;
  final String color;
  final String? remarks;
  final int s21_L;
  final int s20_M;
  final int s19_S;
  final int s23_XL;
  final int s22_XS;
  final int s71_XXL;
  final int total;

  Total({
    required this.styleName,
    required this.styleRef,
    required this.buyerPO,
    required this.tod,
    required this.country,
    required this.color,
    this.remarks,
    required this.s21_L,
    required this.s20_M,
    required this.s19_S,
    required this.s23_XL,
    required this.s22_XS,
    required this.s71_XXL,
    required this.total,
  });

  factory Total.fromJson(Map<String, dynamic> json) {
    return Total(
      styleName: json['StyleName'] ?? '',
      styleRef: json['StyleRef'] ?? '',
      buyerPO: json['BuyerPO'] ?? '',
      tod: json['Tod'] ?? '',
      country: json['Country'] ?? '',
      color: json['Color'] ?? '',
      remarks: json['Remarks'],
      s21_L: json['S21_L'] ?? 0,
      s20_M: json['S20_M'] ?? 0,
      s19_S: json['S19_S'] ?? 0,
      s23_XL: json['S23_XL'] ?? 0,
      s22_XS: json['S22_XS'] ?? 0,
      s71_XXL: json['S71_XXL'] ?? 0,
      total: json['Total'] ?? json['TotalQuantity'] ?? 0,
    );
  }
}

//
class EnhancedProductDisplayScreen extends StatefulWidget {
  final dynamic jsonData;

  const EnhancedProductDisplayScreen({super.key, required this.jsonData});

  @override
  _EnhancedProductDisplayScreenState createState() =>
      _EnhancedProductDisplayScreenState();
}

class _EnhancedProductDisplayScreenState
    extends State<EnhancedProductDisplayScreen> {
  List<Product> products = [];
  List<Extra> extras = [];
  List<Total> totalItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final actualJsonString = widget.jsonData['Actual'];
      final extrasJsonString = widget.jsonData['Extra'];
      final totalJsonString = widget.jsonData['Total'];

      setState(() {
        products = (json.decode(actualJsonString) as List)
            .map((item) => Product.fromJson(item))
            .toList();
        extras = (json.decode(extrasJsonString) as List)
            .map((item) => Extra.fromJson(item))
            .toList();
        totalItems = (json.decode(totalJsonString) as List)
            .map((item) => Total.fromJson(item))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Work Order Details'),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Main Products'),
                    _buildProductTable(products),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Extra Items'),
                    _buildExtraTable(extras),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Total Summary'),
                    _buildTotalTable(totalItems),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildProductTable(List<Product> items) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Main Products',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 1),
          ...items.map((item) => _buildProductRow(item)),
        ],
      ),
    );
  }

  Widget _buildProductRow(Product item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.styleName,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(item.styleNumber),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PO: ${item.buyerPO}'),
              Text('Date: ${item.tod}'),
            ],
          ),
          SizedBox(height: 4),
          Text('Color: ${item.color}', overflow: TextOverflow.ellipsis),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSizeBadge('L', item.s21_L),
              _buildSizeBadge('M', item.s20_M),
              _buildSizeBadge('S', item.s19_S),
              _buildTotalBadge(item.total),
            ],
          ),
          Divider(height: 24),
        ],
      ),
    );
  }

  Widget _buildExtraTable(List<Extra> items) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Extra Items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 1),
          ...items.map((item) => _buildExtraRow(item)),
        ],
      ),
    );
  }

  Widget _buildExtraRow(Extra item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.styleName,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(item.styleRef),
            ],
          ),
          SizedBox(height: 4),
          Text('Country: ${item.country}'),
          SizedBox(height: 4),
          Text('Color: ${item.color}', overflow: TextOverflow.ellipsis),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSizeBadge('XL', item.s23_XL),
              _buildSizeBadge('XS', item.s22_XS),
              _buildSizeBadge('XXL', item.s71_XXL),
              _buildTotalBadge(item.total),
            ],
          ),
          Divider(height: 24),
        ],
      ),
    );
  }

  Widget _buildTotalTable(List<Total> items) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Total Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 1),
          ...items.map((item) => _buildTotalRow(item)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(Total item) {
    final isSummary = item.styleName.isEmpty;
    return Container(
      color: isSummary ? Colors.blue[50] : null,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSummary ? 'Summary' : item.styleName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(item.styleRef),
            ],
          ),
          if (item.remarks != null && item.remarks!.isNotEmpty) ...[
            SizedBox(height: 4),
            Text('Remarks: ${item.remarks}'),
          ],
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSizeBadge('L', item.s21_L, isSummary),
              _buildSizeBadge('M', item.s20_M, isSummary),
              _buildTotalBadge(item.total, isSummary),
            ],
          ),
          Divider(height: 24),
        ],
      ),
    );
  }

  Widget _buildSizeBadge(String size, int quantity,
      [bool isHighlighted = false]) {
    return Column(
      children: [
        Text(size, style: TextStyle(fontSize: 12)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: quantity > 0
                ? (isHighlighted ? Colors.blue[100] : Colors.green[100])
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            quantity.toString(),
            style: TextStyle(
              color: quantity > 0
                  ? (isHighlighted ? Colors.blue[800] : Colors.green[800])
                  : Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalBadge(int total, [bool isHighlighted = false]) {
    return Column(
      children: [
        Text('Total', style: TextStyle(fontSize: 12)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.blue[100] : Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            total.toString(),
            style: TextStyle(
              color: isHighlighted ? Colors.blue[900] : Colors.blue[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
