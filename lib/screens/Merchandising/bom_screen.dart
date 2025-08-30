import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/merchandising_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../models/bom_model.dart';

class BomListScreen extends StatefulWidget {
  const BomListScreen({super.key});

  @override
  State<BomListScreen> createState() => _BomListScreenState();
}

class _BomListScreenState extends State<BomListScreen> {
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
        title: Consumer<MerchandisingProvider>(
          builder: (context, provider, _) {
            return TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search BOM...',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                border: InputBorder.none,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          _searchController.clear();
                          provider.searchBoms('');
                        },
                      )
                    : null,
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) => provider.searchBoms(value),
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
      body: Consumer<MerchandisingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.bomList.isEmpty) {
            return const Center(child: Text('No BOM data available'));
          }
          if (provider.filteredBomList.isEmpty) {
            return const Center(child: Text('No Data Found'));
          }

          return Column(
            children: [
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text('Total: ${provider.filteredBomList.length}   ')),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.filteredBomList.length,
                  itemBuilder: (context, index) {
                    final bom = provider.filteredBomList[index];
                    return _BomCard(bom: bom);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void getAllData() async {
    var mp = context.read<MerchandisingProvider>();
    mp.fetchBomList(
      fromDate: _dateFormat.format(_fromDate),
      toDate: _dateFormat.format(_toDate),
    );
  }
}

class _BomCard extends StatelessWidget {
  final BomModel bom;

  const _BomCard({required this.bom});

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
          backgroundColor: _getStatusColor(bom),
          child: Text(
            bom.bOMCode?.substring(0, 2) ?? 'BM',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          bom.bOMCode ?? 'No BOM Code',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(bom.styleName ?? 'No Style Name'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Buyer', bom.buyer),
                _buildDetailRow('Buyer PO', bom.buyerPo),
                _buildDetailRow('Item', bom.item),
                _buildDetailRow('Color', bom.color),
                _buildDetailRow('Created By', bom.createdBy),
                _buildDetailRow('Created Date', bom.createdDate),
                const SizedBox(height: 8),
                _buildStatusChips(bom),
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

  Widget _buildStatusChips(BomModel bom) {
    return Wrap(
      spacing: 8,
      children: [
        if (bom.isSubmit == true)
          Chip(
            label: const Text('Submitted'),
            backgroundColor: Colors.green[100],
          ),
        if (bom.isLock == true)
          Chip(
            label: const Text('Locked'),
            backgroundColor: Colors.orange[100],
          ),
        if (bom.isLockFinish == true)
          Chip(
            label: const Text('Lock Finished'),
            backgroundColor: Colors.red[100],
          ),
      ],
    );
  }

  Color _getStatusColor(BomModel bom) {
    if (bom.isLockFinish == true) return myColors.primaryColor;
    if (bom.isLock == true) return Colors.orange;
    if (bom.isSubmit == true) return Colors.green;
    return Colors.blue;
  }
}
