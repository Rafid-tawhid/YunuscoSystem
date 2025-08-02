import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/requisation_products_model.dart';


class ProductSelectionScreen extends StatefulWidget {
  @override
  _ProductSelectionScreenState createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  RequisationProductsModel? _selectedProduct;
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAllProducts();
    super.initState();
  }

  void getAllProducts() async {
    var pp = context.read<ProductProvider>();
    pp.getAllRequisationProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.requisationProductList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: (value) => setState(() {}),
        )
            : Text('Select Product'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => _saveAndReturn(context),
            ),
        ],
      ),
      body: _buildProductList(products),
    );
  }

  Widget _buildProductList(List<RequisationProductsModel> products) {
    final searchTerm = _searchController.text.toLowerCase();
    final filteredProducts = searchTerm.isEmpty
        ? products
        : products.where((product) =>
    product.productName?.toLowerCase().contains(searchTerm) == true ||
        product.productCategoryName?.toLowerCase().contains(searchTerm) == true).toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No products found'),
            // if (searchTerm.isNotEmpty)
            //   ElevatedButton(
            //     style: ElevatedButton.styleFrom(backgroundColor: myColors.green),
            //     child: Text('Use "${_searchController.text}"',style: TextStyle(color: Colors.white),),
            //     onPressed: () {
            //       _saveAndReturn(context);
            //     },
            //   ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ListTile(
          title: Text(product.productName ?? 'No Name'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.productCategoryName != null)
                Text('Category: ${product.productCategoryName}'),
              if (product.uomName != null)
                Text('UOM: ${product.uomName}'),
              Divider(height: .1,color: myColors.greyTxt,)
            ],
          ),
          trailing: _selectedProduct?.productId == product.productId
              ? Icon(Icons.check_circle, color: Colors.green)
              : null,
          onTap: () {
            setState(() {
              _selectedProduct = product;
            });
            _saveAndReturn(context);
          },
        );
      },
    );
  }

  void _saveAndReturn(BuildContext context) {
    if (_selectedProduct != null) {
      Navigator.pop(context, _selectedProduct!.productName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a product')),
      );
    }
  }
}