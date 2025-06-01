import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/merchandising_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/approval_top_cards.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../models/costing_approval_list_model.dart';

class CostingApprovalListScreen extends StatefulWidget {
  @override
  State<CostingApprovalListScreen> createState() => _CostingApprovalListScreenState();
}

class _CostingApprovalListScreenState extends State<CostingApprovalListScreen> {
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  final NumberFormat percentFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        _searchFocusNode.unfocus();
        // Clear search results if needed
        context.read<MerchandisingProvider>().clearSearch();
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : const Text('Costing Approvals', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isSearching
                ? IconButton(
                    key: const ValueKey('close'),
                    onPressed: _toggleSearch,
                    icon: const Icon(Icons.close),
                  )
                : IconButton(
                    key: const ValueKey('search'),
                    onPressed: _toggleSearch,
                    icon: const Icon(Icons.search),
                  ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return getAllData(context);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey.shade50, Colors.grey.shade100],
            ),
          ),
          child: Column(
            children: [
              ApprovalTopCards(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 2,
                    color: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Consumer<MerchandisingProvider>(
                      builder: (context, pro, _) {
                        if (pro.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (pro.costingApprovalFilterList.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  'Nothing found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                if (pro.costingApprovalList.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try different search terms',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: pro.costingApprovalFilterList.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                          itemBuilder: (context, index) {
                            final approval = pro.costingApprovalFilterList[index];
                            return _buildApprovalItem(approval);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApprovalItem(CostingApprovalListModel approval) {
    return ExpansionTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getStatusColor(approval.finalStatus).withOpacity(0.2),
        ),
        child: Center(
          child: Icon(
            _getStatusIcon(approval.finalStatus),
            color: _getStatusColor(approval.finalStatus),
            size: 20,
          ),
        ),
      ),
      title: Text(
        'Costing Code: ${approval.costingCode ?? 'N/A'}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            'Buyer: ${approval.buyerName ?? 'N/A'}',
            style: TextStyle(fontSize: 12),
          ),
          Text(
            '${approval.styleName} (${approval.materialMaxBudget}\$ max)',
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${double.parse(approval.profitCostInPercent.toString()).toStringAsFixed(2)}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            approval.finalStatus ?? 'Status N/A',
            style: TextStyle(
              color: _getStatusColor(approval.finalStatus),
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
              _buildDetailRow('Category', approval.catagoryName),
              _buildDetailRow('Style Ref', approval.styleRef),
              _buildDetailRow('Created By', approval.createdBy),
              _buildDetailRow('Created Date', approval.createdDate),
              _buildDetailRow('Submit To', approval.submitToPerson),
              _buildDetailRow('Version', approval.version?.toString()),
              _buildDetailRow('Material Budget', currencyFormat.format(approval.materialMaxBudget)),
              _buildDetailRow('Material Cost', currencyFormat.format(approval.materialCost)),
              _buildDetailRow('Buying Cost', currencyFormat.format(approval.buyingCost)),
              _buildDetailRow('CM', currencyFormat.format(approval.cm)),
              _buildDetailRow('SMV', approval.smv?.toString()),
              _buildDetailRow('Profit %', percentFormat.format((approval.profitCostInPercent ?? 0) / 100)),
              _buildDetailRow('Total Qty', approval.totalOrderQty?.toString()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  DashboardHelpers.showConfirmDialog(
                      context: context,
                      title: 'Reject!',
                      message: 'Do you sure want to reject?',
                      confirmText: 'Reject',
                      cancelText: 'No',
                      acceptButtonColor: Colors.red.shade400,
                      onCancel: () {},
                      onSubmit: () {
                        rejectItem(approval);
                      });
                },
                child: const Text(
                  'Reject',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Costing Code : ${approval.costingCode}');
                  DashboardHelpers.openUrl('${AppConstants.baseUrl}Merchandising/MerchandisingReport/CostSheet?CostingCode=${approval.costingCode}&version=0');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: Text(
                  'Details',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  acceptItem(approval);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: approval.finalStatus == 'Pending' ? Colors.green : Colors.orange,
                ),
                child: Text(
                  approval.finalStatus == 'Pending' ? 'Accept' : 'View',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'Approved':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.cancel;
      case 'Pending':
        return Icons.access_time;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildSearchField() {
    var mp = context.read<MerchandisingProvider>();
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search approvals...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16),
      onChanged: (query) async {
        mp.setLoading(true);
        mp.searchCostingApprovals(query);
        await Future.delayed(Duration(milliseconds: 500));
        mp.setLoading(false);
      },
    );
  }

  Future<void> getAllData(BuildContext context) async {
    try {
      final mp = context.read<MerchandisingProvider>();
      // Use Future.micro task if you need to avoid direct execution in initState
      await mp.getCostingApprovalList(DashboardHelpers.currentUser!.userId.toString()); // Consider using a real user ID
    } catch (e) {
      debugPrint('Error loading data: $e');
      // Optionally show error to user
    }
  }

  void rejectItem(CostingApprovalListModel approval) {
    try {
      final approvalItem = [
        {
          'ApprovalId': approval.approvalId,
          'CurrentApprover': approval.currentApprover,
          'AprrovalPolicyId': approval.aprrovalPolicyId,
          'ApprovalLevel': approval.approvalLevel,
          'ApprovalTypeId': approval.approvalTypeId,
          'AprrovalTypePrimaryKey': approval.aprrovalTypePrimaryKey,
        }
      ];

      var mp = context.read<MerchandisingProvider>();
      mp.acceptRejectConstingApproval(approvalItem, url: 'HR/Approval/CommonReject');
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
    }
  }

  void acceptItem(CostingApprovalListModel approval) {
    try {
      final approvalItem = [
        {
          'ApprovalId': approval.approvalId,
          'CurrentApprover': approval.currentApprover,
          'AprrovalPolicyId': approval.aprrovalPolicyId,
          'ApprovalLevel': approval.approvalLevel,
          'ApprovalTypeId': approval.approvalTypeId,
          'AprrovalTypePrimaryKey': approval.aprrovalTypePrimaryKey,
        }
      ];

      var mp = context.read<MerchandisingProvider>();
      mp.acceptRejectConstingApproval(approvalItem, url: 'HR/Approval/ApproveNew');
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
    }
  }
}
