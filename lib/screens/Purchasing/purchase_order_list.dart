import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../models/purchase_order_model.dart';



class PurchaseOrdersListScreen extends StatefulWidget {
  final List<PurchaseOrderModel> purchaseOrders;

  const PurchaseOrdersListScreen({Key? key, required this.purchaseOrders}) : super(key: key);

  @override
  _PurchaseOrdersListScreenState createState() => _PurchaseOrdersListScreenState();
}

class _PurchaseOrdersListScreenState extends State<PurchaseOrdersListScreen> {
  // Filtering variables

  String _filterStatus = 'All';
  String _filterType = 'All';
  int _currentPage = 1;
  final int _itemsPerPage = 50;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
   // getPurchaseInfo();
    super.initState();
  }
  void getPurchaseInfo() {
    var pp=context.read<ProductProvider>();
    //pp.getAllPurchaseList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
          onChanged: (value) {
            // 🔍 Handle search logic here
            print("Searching for $value");
          },
        )
            : const Text("Purchase Orders"),
        backgroundColor: myColors.primaryColor, // your myColors.primaryColor
        foregroundColor: Colors.white,
        elevation: 0,
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
        ],
      ),
      body: Column(
        children: [

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.purchaseOrders.length} orders found',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                if (_filterStatus != 'All' || _filterType != 'All')
                  InkWell(
                    onTap: () {
                      setState(() {
                        _filterStatus = 'All';
                        _filterType = 'All';
                      });
                    },
                    child: Text(
                      'Clear filters',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Purchase orders list
          Expanded(
            child: widget.purchaseOrders.isEmpty
                ? _buildEmptyState()
                : Consumer<ProductProvider>(
                  builder: (context,pro,_)=>pro.isLoading?Center(child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator())):ListView.builder(
                    itemCount: widget.purchaseOrders.length,
                    itemBuilder: (context, index) {
                      return _buildOrderCard(widget.purchaseOrders[index]);
                    },
                  ),
                ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: IconButton(onPressed: () async {
                  setState(() {
                    _currentPage=_currentPage-1;
                  });
                  debugPrint('_currentPage $_currentPage');
                  var pp=context.read<ProductProvider>();
                  await pp.getAllPurchaseList(_currentPage.toString(),'50');
                }, icon: Icon(Icons.arrow_back_ios)),
              ),
              Text(_currentPage.toString(),style: customTextStyle(20, Colors.black, FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: IconButton(onPressed: () async {
                  setState(() {
                    _currentPage=_currentPage+1;
                  });
                  var pp=context.read<ProductProvider>();
                  debugPrint('_currentPage $_currentPage');
                  await pp.getAllPurchaseList(_currentPage.toString(),'50');
                }, icon: Icon(Icons.arrow_forward_ios)),
              ),

            ],
          ),
          // PaginationBox(
          //   totalItems: 500,
          //   currentPage: 1,
          //   itemsPerPage: 50,
          //   onPageChanged: (page) {
          //     setState(() {
          //       _currentPage = page;
          //     });
          //     debugPrint('_currentPage $_currentPage');
          //   },
          // ),

        ],
      ),
    );
  }

  Widget _buildOrderCard(PurchaseOrderModel order) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Handle order tap (view details)
          _showOrderDetails(order);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with order code and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.purchaseOrderCode ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: order.isConfirmed == true ? Colors.green.shade100 : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.isConfirmed == true ? 'Confirmed' : 'Pending',
                      style: TextStyle(
                        color: order.isConfirmed == true ? Colors.green.shade800 : Colors.orange.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Order details
              _buildDetailRow('Supplier', order.supplierName ?? 'N/A'),
              const SizedBox(height: 8),
              _buildDetailRow('Order Date', _formatDate(order.orderDate)),
              const SizedBox(height: 8),
              _buildDetailRow('Type', '${order.orderType} • ${order.purchaseType}'),
              const SizedBox(height: 8),
              if (order.approve != null) _buildDetailRow('Approver', order.approve!),
              if (order.remarks != null && order.remarks!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Remarks', order.remarks!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<dynamic> get _currentPageItems {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return widget.purchaseOrders.sublist(
      startIndex,
      endIndex > widget.purchaseOrders.length ? widget.purchaseOrders.length : endIndex,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No purchase orders found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }



  void _showOrderDetails(PurchaseOrderModel order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          initialChildSize: 0.7,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.purchaseOrderCode ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: order.isConfirmed == true ? Colors.green.shade100 : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            order.isConfirmed == true ? 'Confirmed' : 'Pending',
                            style: TextStyle(
                              color: order.isConfirmed == true ? Colors.green.shade800 : Colors.orange.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem('Supplier', order.supplierName ?? 'N/A'),
                    _buildDetailItem('Order Date', _formatDate(order.orderDate)),
                    _buildDetailItem('Order Type', order.orderType ?? 'N/A'),
                    _buildDetailItem('Purchase Type', order.purchaseType ?? 'N/A'),
                    if (order.approvalFieldCode != null) _buildDetailItem('Approval Code', order.approvalFieldCode.toString()),
                    if (order.approve != null) _buildDetailItem('Approver', order.approve!),
                    if (order.remarks != null && order.remarks!.isNotEmpty) _buildDetailItem('Remarks', order.remarks!),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle action button
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:  Text('View Full Details',style: customTextStyle(18, Colors.white, FontWeight.normal),),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';

    try {
      final DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}


