import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';

import '../../models/buyer_wise_material_model.dart';

class BuyerWiseMaterialList extends StatelessWidget {
  final String buyerName;

  const BuyerWiseMaterialList({Key? key, required this.buyerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title:  Text('$buyerName Materials',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[800]!, Colors.purple[600]!],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsHeader(),
          Expanded(
            child: Consumer<ProductProvider>(builder: (context,provider,_)=>_buildMaterialList(provider)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
        BoxShadow(
        color: Colors.black12,
        blurRadius: 4,
        offset: Offset(0, 2),)
        ],
      ),
      child: Consumer<ProductProvider>(
        builder: (context,provider,_)=>Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Buyers', provider.buyerMaterialList.length.toString(),
                Colors.blue),
            _buildStatItem('Categories',
                provider.buyerMaterialList.map((e) => e.productCategoryName).toSet().length.toString(),
                Colors.green),
            _buildStatItem('Products',
                provider.buyerMaterialList.map((e) => e.productName).toSet().length.toString(),
                Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialList(ProductProvider provider) {

    if (provider.buyerMaterialList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Materials Found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.buyerMaterialList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final material = provider.buyerMaterialList[index];
        return _buildMaterialCard(material);
      },
    );
  }

  Widget _buildMaterialCard(BuyerWiseMaterialModel material) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Handle item tap
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buyer Info Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          material.buyerName ?? 'Unknown Buyer',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Text(
                        //   'ID: ${material.buyerId ?? 'N/A'}',
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     color: Colors.grey[600],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(material.typeName),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      material.typeName ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Product Info
              _buildInfoRow('Category', material.productCategoryName),
              _buildInfoRow('Product', material.productName),
              _buildInfoRow('Unit', material.uomName),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String? typeName) {
    switch (typeName?.toLowerCase()) {
      case 'regular':
        return Colors.green;
      case 'premium':
        return Colors.purple;
      case 'wholesale':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _showSearch(BuildContext context) {
    var pp=context.read<ProductProvider>();
    showSearch(
      context: context,
      delegate: _BuyerMaterialSearchDelegate(pp.buyerMaterialList),
    );
  }
}

class _BuyerMaterialSearchDelegate extends SearchDelegate {
  final List<BuyerWiseMaterialModel> materials;

  _BuyerMaterialSearchDelegate(this.materials);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = query.isEmpty
        ? materials
        : materials.where((material) =>
    (material.buyerName?.toLowerCase().contains(query.toLowerCase()) ??
        false) ||
        (material.productName?.toLowerCase().contains(query.toLowerCase()) ??
            false) ||
        (material.productCategoryName
            ?.toLowerCase()
            .contains(query.toLowerCase()) ??
            false)).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final material = results[index];
        return ListTile(

          leading: CircleAvatar(
            backgroundColor: Colors.blue[50],
            child: Text(material.buyerName?.substring(0, 1) ?? '?'),
          ),
          title: Text(material.buyerName ?? 'Unknown Buyer'),
          subtitle: Text(material.productName ?? 'Unknown Product'),
          trailing: Text(material.typeName ?? 'N/A',
              style: TextStyle(
                  color: _getTypeColor(material.typeName),
                  fontWeight: FontWeight.bold)),
          onTap: () {
            // Handle item selection
          },
        );
      },
    );
  }

  Color _getTypeColor(String? typeName) {
    switch (typeName?.toLowerCase()) {
      case 'regular':
        return Colors.green;
      case 'premium':
        return Colors.purple;
      case 'wholesale':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}