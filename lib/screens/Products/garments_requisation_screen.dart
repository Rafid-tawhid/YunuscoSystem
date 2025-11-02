import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import '../../../models/production_goods_model.dart';

class GarmentsRequisitionScreen extends StatefulWidget {
  const GarmentsRequisitionScreen({super.key});

  @override
  State<GarmentsRequisitionScreen> createState() =>
      _GarmentsRequisitionScreenState();
}

class _GarmentsRequisitionScreenState extends State<GarmentsRequisitionScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      getAllData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2000),
      lastDate: _toDate,
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
        getAllData();
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: _fromDate,
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
        getAllData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Consumer<ProductProvider>(
          builder: (context, provider, _) {
            return TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Requisitions...',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                border: InputBorder.none,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          _searchController.clear();
                          provider.searchRequisitions('');
                        },
                      )
                    : null,
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) => provider.searchRequisitions(value),
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(_dateFormat.format(_fromDate)),
                    onPressed: () => _selectFromDate(context),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('to'),
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(_dateFormat.format(_toDate)),
                    onPressed: () => _selectToDate(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.requisitionList.isEmpty) {
            return const Center(child: Text('No requisition data available'));
          }
          if (provider.filteredRequisitionList.isEmpty) {
            return const Center(child: Text('No Data Found'));
          }

          return ListView.builder(
            itemCount: provider.filteredRequisitionList.length,
            itemBuilder: (context, index) {
              final requisition = provider.filteredRequisitionList[index];
              return _RequisitionCard(requisition: requisition);
            },
          );
        },
      ),
    );
  }

  void getAllData() async {
    var pp = context.read<ProductProvider>();
    pp.fetchRequisitionList(
      fromDate: _dateFormat.format(_fromDate),
      toDate: _dateFormat.format(_toDate),
    );
  }
}

class _RequisitionCard extends StatelessWidget {
  final ProductionGoodsModel requisition;

  const _RequisitionCard({required this.requisition});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(requisition),
          child: Text(
            requisition.requisitionCode?.substring(0, 2) ?? 'RQ',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          requisition.requisitionCode ?? 'No Requisition Code',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(requisition.buyerOrderCode ?? 'No Order Code'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Buyer PO', requisition.buyerPo),
                _buildDetailRow('Style Code', requisition.styleCode),
                _buildDetailRow('Batch No', requisition.batchNo),
                _buildDetailRow('BOM Code', requisition.bomcode),
                _buildDetailRow('Created By', requisition.createdBy?.toString()),
                _buildDetailRow('Created Date', requisition.createdDate),
                _buildDetailRow('Remarks', requisition.remarks),
                const SizedBox(height: 8),
                _buildStatusChips(requisition),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  Widget _buildStatusChips(ProductionGoodsModel requisition) {
    return Wrap(
      spacing: 8,
      children: [
        if (requisition.isIssued == true)
          Chip(
            label: const Text('Issued'),
            backgroundColor: Colors.green[100],
          ),
        if (requisition.partiallyIssued == true)
          Chip(
            label: const Text('Partially Issued'),
            backgroundColor: Colors.orange[100],
          ),
      ],
    );
  }

  Color _getStatusColor(ProductionGoodsModel requisition) {
    if (requisition.isIssued == true) return Colors.green;
    if (requisition.partiallyIssued == true) return Colors.orange;
    return Colors.blue;
  }
}
