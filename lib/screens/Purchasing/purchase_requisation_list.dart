import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/screens/Purchasing/widgets/purchase_product_details.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';
import '../../models/purchase_requisation_list_model.dart';
import 'create_purchase_requisation.dart';


class PurchaseRequisitionListScreen extends StatefulWidget {
  const PurchaseRequisitionListScreen({super.key});

  @override
  State<PurchaseRequisitionListScreen> createState() =>
      _PurchaseRequisitionListScreenState();
}

class _PurchaseRequisitionListScreenState
    extends State<PurchaseRequisitionListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getAllRequisitions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        // Reset the search filter in provider
        Provider.of<ProductProvider>(context, listen: false).filterRequisitions('');
      }
    });
  }

  void _onSearchChanged(String query) {
    Provider.of<ProductProvider>(context, listen: false).filterRequisitions(query);
  }

  Future<void> _refreshData() async {
    await Provider.of<ProductProvider>(context, listen: false).getAllRequisitions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: myColors.primaryColor,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search requisitions...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        )
            : const Text(
          'Purchase Requisitions',
          style: TextStyle(color: Colors.white),
        ),
        leading: _isSearching
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _toggleSearch();
            Navigator.pop(context);
          },
        )
            : IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: _toggleSearch,
            ),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(backgroundColor: myColors.green),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                            const CreatePurchaseRequisitionScreen()));
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Create',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final displayRequisitions = _isSearching
                    ? provider.filteredRequisitions
                    : provider.requisitions;

                if (displayRequisitions.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                          child: Text(
                            _isSearching ? 'No matching requisitions found.' : 'No requisition found.',
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshData,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text('Total : ${displayRequisitions.length}'),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: displayRequisitions.length,
                          itemBuilder: (context, index) {
                            final requisition = displayRequisitions[index];
                            return _buildRequisitionCard(requisition);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequisitionCard(PurchaseRequisationListModel requisition) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          // Navigate to detail screen
          var pp = context.read<ProductProvider>();
          var res = await pp.getRequisationProductDetails(
              requisition.purchaseRequisitionCode);
          if (res) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RequisitionDetailsScreen(
                        requisitions: pp.requisationProductDetails,reqModel: requisition)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    requisition.purchaseRequisitionCode ?? 'No Code',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Chip(
                    label: Text(requisition.mgntComment??'Pending',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: getBgColor(requisition.mgntComment),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.person, requisition.userName ?? 'Unknown'),
              if (requisition.department != null)
                _buildInfoRow(Icons.business,
                    requisition.department?.toString() ?? 'No Department'),
              _buildInfoRow(
                  Icons.category, requisition.productType ?? 'No Product Type'),
              _buildInfoRow(
                  Icons.calendar_today,
                  DashboardHelpers.convertDateTime(
                      requisition.createdDate ?? '') ??
                      'No Date'),
              _buildInfoRow(
                  Icons.info_outline,
                 requisition.productType??''),
              if (requisition.remarks?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  'Remarks: ${requisition.remarks}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  getBgColor(String? mgntComment) {
    if(PurchaseStatus.deptHeadRejected==mgntComment)
      {
        return Colors.redAccent;
      }
    if(PurchaseStatus.managementRejected==mgntComment)
    {
      return Colors.red;
    }
    if(PurchaseStatus.deptHeadApproved==mgntComment)
    {
      return Colors.green.shade400;
    }
    if(PurchaseStatus.managementApproved==mgntComment)
    {
      return Colors.green;
    }
    else
      {
        return Colors.orange;
      }
  }
}
