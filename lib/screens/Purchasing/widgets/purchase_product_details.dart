import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';

import '../../../models/purchase_requisation_list_model.dart';
import '../../../models/requisition_details_model.dart';
import '../purchase_requisation_list.dart';

class RequisitionDetailsScreen extends StatelessWidget {
  final List<RequisitionDetailsModel> requisitions;
  final PurchaseRequisationListModel reqModel;


  const RequisitionDetailsScreen({super.key, required this.requisitions,required this.reqModel});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _remarksController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Requisition Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requisitions.length + 1, // Add 1 for the remarks section
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index < requisitions.length) {
            final req = requisitions[index];
            return _buildRequisitionCard(req, context);
          } else {
            if(reqModel.isComplete==null)
              {
                return  Column(
                  children: [
                    const SizedBox(height: 16),
                    TextField(
                      controller: _remarksController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter your remarks here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              var pp=context.read<ProductProvider>();
                              var data=await pp.acceptItem(reqModel,_remarksController.text.trim(),false);
                              if(data){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PurchaseRequisitionListScreen()));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Reject', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {

                              var pp=context.read<ProductProvider>();
                              var data=await pp.acceptItem(reqModel,_remarksController.text.trim(),true);
                              if(data){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PurchaseRequisitionListScreen()));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Accept', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                );
              }
           else {
            return SizedBox.shrink();
            }
          }
        },
      )
    );
  }

  Widget _buildRequisitionCard(
      RequisitionDetailsModel req, BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Align(
              alignment: Alignment.topRight,
              child: Text(_formatDate(req.requisitionDate)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with validation
                _buildProductImage(req),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.product ?? 'No Product Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Req #${req.requisitionCode ?? 'N/A'} •',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Chip
                // if (req.status != null)
                //   Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //     decoration: BoxDecoration(
                //       color: _getStatusColor(req.status),
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Text(
                //       req.status!,
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 12,
                //       ),
                //     ),
                //   ),
              ],
            ),

            const SizedBox(height: 16),

            // Details Section
            _buildDetailSection(req),

            const SizedBox(height: 8),

            // Quantity Summary
            _buildQuantitySummary(req),

            const SizedBox(height: 16),

            // Last Purchase Info
            _buildLastPurchaseInfo(req),

            const SizedBox(height: 8),

            // Notes if available
            if (req.note?.isNotEmpty == true) _buildNotesSection(req),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(RequisitionDetailsModel req) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: req.imagePathString != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: req.imagePathString!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.inventory, size: 30),
              ),
            )
          : const Center(
              child: Icon(Icons.inventory, size: 30),
            ),
    );
  }

  Widget _buildDetailSection(RequisitionDetailsModel req) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Employee', req.employeeName),
        _buildDetailRow('Department', req.department),
        _buildDetailRow('Section', req.section),
        _buildDetailRow(
            'Product Description', req.productDescription?.toString()),
        _buildDetailRow('Unit', '${req.unit} (${req.unitId})'),
        _buildDetailRow('Required By', _formatDate(req.requiredDate)),
        _buildDetailRow('Approved By', req.approvedBy),
        _buildDetailRow('Approval Type', req.approvalType),
      ],
    );
  }

  Widget _buildQuantitySummary(RequisitionDetailsModel req) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuantityPill('Requested', req.actualReqQty, Colors.orange),
          _buildQuantityPill('Approved', req.approvedQty, Colors.green),
          _buildQuantityPill(
              'In Stock',
              req.iNHandQty,
              req.iNHandQty != null && req.iNHandQty! < 10
                  ? Colors.red
                  : Colors.blue),
        ],
      ),
    );
  }

  Widget _buildQuantityPill(String label, num? value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            value?.toString() ?? '0',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastPurchaseInfo(RequisitionDetailsModel req) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LAST PURCHASE INFO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildPurchaseDetailRow(
                  'Date', _formatDate(req.lastPurchaseDate)),
              _buildPurchaseDetailRow('Supplier', req.supplierName),
              _buildPurchaseDetailRow(
                  'Rate', req.lastPurchaseRate?.toStringAsFixed(2)),
              _buildPurchaseDetailRow(
                  'Total', '\$${req.totalPurchaseAmount?.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(RequisitionDetailsModel req) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NOTES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            req.note!,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  //
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseDetailRow(String label, String? value) {
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
          const SizedBox(width: 8),
          Text(
            value ?? 'N/A',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
