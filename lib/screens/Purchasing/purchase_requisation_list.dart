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
  State<PurchaseRequisitionListScreen> createState() => _PurchaseRequisitionListScreenState();
}

class _PurchaseRequisitionListScreenState extends State<PurchaseRequisitionListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isFetchingMore = false;
  String selectedValue = 'All';
  List<PurchaseRequisationListModel> _filteredList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getAllRequisitions(pageNo: _currentPage);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        Provider.of<ProductProvider>(context, listen: false).filterRequisitions('');
      }
    });
  }

  void _onSearchChanged(String query) {
    Provider.of<ProductProvider>(context, listen: false).filterRequisitions(query);
  }

  Future<void> _refreshData() async {
    await Provider.of<ProductProvider>(context, listen: false).getAllRequisitions(pageNo: 1);
  }

  void _applyFilter(String value, List<PurchaseRequisationListModel> allRequisitions) {
    setState(() {
      selectedValue = value;
      _isSearching = false;

      if (value == 'All') {
        _filteredList = allRequisitions;
      } else if (value == 'Pending') {
        if (DashboardHelpers.currentUser!.department == '15') {
          // Management user
          _filteredList = allRequisitions.where((e) => e.mgntComment == PurchaseStatus.deptHeadApproved).toList();
        } else {
          // Regular user
          _filteredList = allRequisitions.where((e) => e.mgntComment == null || e.mgntComment!.isEmpty).toList();
        }
      } else if (value == 'Approved') {
        if (DashboardHelpers.currentUser!.department == '15') {
          // Management user
          _filteredList = allRequisitions.where((e) =>
          (e.mgntComment == PurchaseStatus.managementApproved) ||
              e.mgntComment == PurchaseStatus.managementRejected
          ).toList();
        } else {
          // Regular user
          _filteredList = allRequisitions.where((e) => e.mgntComment == PurchaseStatus.deptHeadApproved).toList();
        }
      }
    });
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
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const CreatePurchaseRequisitionScreen())
                );
              },
              icon: const Icon(Icons.add, color: Colors.white)
          )
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          // FIX: Initialize filtered list when provider data is available
          if (_filteredList.isEmpty && provider.requisitions.isNotEmpty) {
            _filteredList = List.from(provider.requisitions);
          }

          final displayRequisitions = _isSearching ? provider.filteredRequisitions : _filteredList;

          return Column(
            children: [
              Expanded(
                child: _buildContent(provider, displayRequisitions),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(ProductProvider provider, List<PurchaseRequisationListModel> displayRequisitions) {
    if (provider.isLoading && provider.requisitions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

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
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Text('Total : ${displayRequisitions.length}'),
                const Spacer(),
                Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(12),
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All')),
                          DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                          DropdownMenuItem(value: 'Approved', child: Text('Approved')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            _applyFilter(value, provider.requisitions);
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Requisitions List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
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
  }

  Widget _buildRequisitionCard(PurchaseRequisationListModel requisition) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          var pp = context.read<ProductProvider>();
          var res = await pp.getRequisationProductDetails(requisition.purchaseRequisitionCode);
          if (res) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RequisitionDetailsScreen(
                        requisitionsList: pp.requisationProductDetails,
                        reqModel: requisition
                    )
                )
            );
          }
        },
        child: Stack(
          children: [
            Padding(
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person, requisition.userName ?? 'Unknown'),
                  if (requisition.department != null)
                    _buildInfoRow(Icons.business, requisition.department?.toString() ?? 'No Department'),
                  _buildInfoRow(Icons.category, requisition.productType ?? 'No Product Type'),
                  _buildInfoRow(Icons.calendar_today, DashboardHelpers.convertDateTime(requisition.createdDate ?? '') ?? 'No Date'),
                  _buildInfoRow(Icons.info_outline, requisition.productType ?? ''),
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
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: getBgColor(requisition.mgntComment),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  requisition.isComplete == true
                      ? PurchaseStatus.managementApproved
                      : requisition.mgntComment ?? 'Pending',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
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
}

getBgColor(String? mgntComment) {
  if (PurchaseStatus.deptHeadRejected == mgntComment) {
    return Colors.redAccent;
  }
  if (PurchaseStatus.managementRejected == mgntComment) {
    return Colors.red;
  }
  if (PurchaseStatus.deptHeadApproved == mgntComment) {
    return Colors.green;
  }
  if (PurchaseStatus.managementApproved == mgntComment) {
    return Colors.blueAccent;
  } else {
    return Colors.orange;
  }
}