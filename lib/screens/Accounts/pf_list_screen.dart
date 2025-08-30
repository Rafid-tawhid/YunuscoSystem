import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../models/pf_main_model.dart';
import '../../providers/account_provider.dart';

class PfListScreen extends StatefulWidget {
  const PfListScreen({super.key});

  @override
  State<PfListScreen> createState() => _PfListScreenState();
}

class _PfListScreenState extends State<PfListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Consumer<AccountProvider>(
          builder: (context, provider, _) {
            return TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search PF Records...',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                border: InputBorder.none,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          _searchController.clear();
                          provider.searchPfRecords('');
                        },
                      )
                    : null,
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) => provider.searchPfRecords(value),
            );
          },
        ),
      ),
      body: Consumer<AccountProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.pfList.isEmpty) {
            return const Center(child: Text('No PF records available'));
          }

          if (provider.filteredPfList.isEmpty) {
            return const Center(child: Text('No matching records found'));
          }

          return ListView.builder(
            itemCount: provider.filteredPfList.length,
            itemBuilder: (context, index) {
              final pfRecord = provider.filteredPfList[index];
              return _PfCard(pfRecord: pfRecord);
            },
          );
        },
      ),
    );
  }

  void getAllData() async {
    final provider = context.read<AccountProvider>();
    await provider.fetchPfList();
  }
}

class _PfCard extends StatelessWidget {
  final PfMainModel pfRecord;

  const _PfCard({required this.pfRecord});

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
          backgroundColor: _getStatusColor(pfRecord),
          child: Text(
            pfRecord.pfvoucherNo?.substring(0, 2) ?? 'PF',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          pfRecord.employeeName ?? 'No Employee Name',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            '${pfRecord.department ?? ''} • ${pfRecord.designation ?? ''}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Voucher No', pfRecord.pfvoucherNo),
                _buildDetailRow('ID Card', pfRecord.idCardNo),
                _buildDetailRow('Section', pfRecord.section),
                _buildDetailRow('Join Date', pfRecord.joinDate),
                _buildDetailRow('Bank', pfRecord.bankName),
                _buildDetailRow('Account No', pfRecord.salaryAccountNo),
                const SizedBox(height: 12),
                _buildAmountRow(
                    'Employee Contribution', pfRecord.totalEmployeeAmount),
                _buildAmountRow(
                    'Company Contribution', pfRecord.totalCompanyAmount),
                _buildAmountRow('Total PF Amount', pfRecord.totalAmount,
                    isTotal: true),
                const SizedBox(height: 8),
                if (pfRecord.pfdeactivatedDate != null)
                  _buildStatusRow(
                      'Deactivated on ${pfRecord.pfdeactivatedDate}'),
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
            width: 120,
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

  Widget _buildAmountRow(String label, num? amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            '৳${amount?.toStringAsFixed(2) ?? '0.00'}',
            style: TextStyle(
              color: Colors.green,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.red[100],
      labelStyle: const TextStyle(color: Colors.red),
    );
  }

  Color _getStatusColor(PfMainModel pfRecord) {
    return pfRecord.pfdeactivatedDate != null ? Colors.red : myColors.green;
  }
}
