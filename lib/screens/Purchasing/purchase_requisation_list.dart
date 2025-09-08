import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/screens/Purchasing/widgets/purchase_product_details.dart';
import 'package:yunusco_group/utils/colors.dart';
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
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getAllRequisitions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: myColors.primaryColor,
        title: const Text(
          'Purchase Requisitions',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () =>
                Provider.of<ProductProvider>(context, listen: false)
                    .getAllRequisitions(),
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
                                CreatePurchaseRequisitionScreen()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Create',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Icon(
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
                  return Center(child: CircularProgressIndicator());
                } else if (provider.requisitions.isEmpty) {
                  return const Center(child: Text('No requisition found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.requisitions.length,
                  itemBuilder: (context, index) {
                    final requisition = provider.requisitions[index];
                    return _buildRequisitionCard(requisition);
                  },
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
                        requisitions: pp.requisationProductDetails)));
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
                    label: Text(
                      requisition.isComplete == true ? 'Completed' : 'Pending',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: requisition.isComplete == true
                        ? Colors.green
                        : Colors.orange,
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

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
