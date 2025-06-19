import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/approval_top_cards.dart';

import '../../models/purchase_approval_model.dart';
import '../../providers/merchandising_provider.dart';
import '../../utils/constants.dart';

class PurchaseApprovalScreen extends StatefulWidget {
  const PurchaseApprovalScreen({Key? key}) : super(key: key);

  @override
  _PurchaseApprovalScreenState createState() => _PurchaseApprovalScreenState();
}

class _PurchaseApprovalScreenState extends State<PurchaseApprovalScreen> {
  bool _isLoading = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  final dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v){
      _loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<MerchandisingProvider>(context, listen: false);
    setState(() => _isLoading = true);
    final success = await provider.getAllPurchaseData();
    setState(() => _isLoading = false);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load purchase data')),
      );
    }
  }

  List<PurchaseApprovalModel> _getFilteredList(List<PurchaseApprovalModel> list) {
    if (_searchController.text.isEmpty) return list;

    return list.where((item) {
      return item.purchaseOrderCode!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          item.buyerName!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          item.supplierName!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          item.finalStatus!.toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    final purchaseList = Provider.of<MerchandisingProvider>(context).purchaseApprovalList;
    final filteredList = _getFilteredList(purchaseList);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredList.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No purchase approvals found'
                  : 'No results for "${_searchController.text}"',
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (_searchController.text.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _isSearching = false;
                  });
                },
                child: const Text('Clear search'),
              ),
          ],
        ),
      )
          : Column(
            children: [
              ApprovalTopCards(isPurchase: true,),
              Expanded(
                child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                return _buildPurchaseItem(filteredList[index]);
                        },
                      ),
              ),
            ],
          ),
    );
  }

  Widget _buildPurchaseItem(PurchaseApprovalModel purchase) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getStatusColor(purchase.finalStatus).withOpacity(0.2),
          ),
          child: Center(
            child: Icon(
              _getStatusIcon(purchase.finalStatus),
              color: _getStatusColor(purchase.finalStatus),
              size: 20,
            ),
          ),
        ),
        title: Text(
          'PO: ${purchase.purchaseOrderCode ?? 'N/A'}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Buyer: ${purchase.buyerName ?? 'N/A'}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Supplier: ${purchase.supplierName ?? 'N/A'}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(purchase.totalAmount ?? 0),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              purchase.finalStatus ?? 'Status N/A',
              style: TextStyle(
                color: _getStatusColor(purchase.finalStatus),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              children: [
                _buildDetailRow('Created By', purchase.createdBy),
                _buildDetailRow('Created Date',
                    purchase.createdDate != null
                        ? dateFormat.format(DateTime.parse(purchase.createdDate!))
                        : 'N/A'),
                _buildDetailRow('Submit To', purchase.submitToPerson),
                _buildDetailRow('Style Number', purchase.styleNumber?.toString()),
                _buildDetailRow('Buyer PO', purchase.buyerPO?.toString()),
                _buildDetailRow('Buyer Order Code', purchase.buyerOrderCode?.toString()),
                _buildDetailRow('Costsheet Code', purchase.costsheetCode?.toString()),
                _buildDetailRow('Total Qty', purchase.totalOrderQty?.toString()),
                _buildDetailRow('Version', purchase.version?.toString()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (purchase.finalStatus == 'Pending') ...[
                  TextButton(
                    onPressed: () => _showRejectDialog(purchase),
                    child: const Text(
                      'Reject',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                ElevatedButton(
                  onPressed: () {
                    // Add your details action here
                    debugPrint('View details for ${purchase.purchaseOrderCode}');
                  //  DashboardHelpers.openUrl('http://202.74.243.118:1726/Merchandising/MerchandisingReport/PurchaseOrderReport?POCode=${purchase.purchaseOrderCode}&version=0');
                    DashboardHelpers.openUrl('${AppConstants.liveUrl}Merchandising/MerchandisingReport/PurchaseOrderReport?POCode=${purchase.purchaseOrderCode}&version=0');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (purchase.finalStatus == 'Pending') {
                      _acceptPurchase(purchase);
                    } else {
                      // View action for non-pending items
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purchase.finalStatus == 'Pending'
                        ? Colors.green
                        : Colors.blue,
                  ),
                  child: Text(
                    purchase.finalStatus == 'Pending' ? 'Accept' : 'View',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.access_time;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  void _showRejectDialog(PurchaseApprovalModel purchase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Purchase Order'),
        content: const Text('Are you sure you want to reject this purchase order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _rejectPurchase(purchase);
            },
            child: const Text(
              'Reject',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _acceptPurchase(PurchaseApprovalModel purchase) async {
    // Implement your accept logic here
    debugPrint('Accepting PO: ${purchase.purchaseOrderCode}');
  }

  Future<void> _rejectPurchase(PurchaseApprovalModel purchase) async {
    // Implement your reject logic here
    debugPrint('Rejecting PO: ${purchase.purchaseOrderCode}');
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _isSearching
          ? TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search purchases...',
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _isSearching = false;
              });
            },
          ),
        ),
        onChanged: (_) => setState(() {}),
      )
          : const Text('Purchase Approvals'),
      actions: [
        if (!_isSearching)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => setState(() => _isSearching = true),
          ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadData,
        ),
      ],
    );
  }
}