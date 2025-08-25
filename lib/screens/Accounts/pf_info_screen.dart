import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/account_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

class PfInfoScreen extends StatelessWidget {
  const PfInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('Provident Fund Information',style: customTextStyle(18, Colors.white, FontWeight.w500),),
        backgroundColor: myColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: context.read<AccountProvider>().fetchPfAmount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading data',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No PF data available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final pfData = snapshot.data!;
          return _buildPfInfoCard(pfData);
        },
      ),
    );
  }

  Widget _buildPfInfoCard(Map<String, dynamic> pfData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with user info
             // _buildInfoRow('User ID', pfData['UserId']?.toString() ?? 'N/A'),
              _buildInfoRow('ID Card No', pfData['IdCardNo']?.toString() ?? 'N/A'),
              _buildInfoRow('Full Name', pfData['FullName']?.toString() ?? 'N/A'),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Employment details
              _buildInfoRow('Department', pfData['DepartmentName']?.toString() ?? 'N/A'),
              _buildInfoRow('Designation', pfData['DesignationName']?.toString() ?? 'N/A'),
              _buildInfoRow('Section', pfData['SectionName']?.toString() ?? 'N/A'),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // PF details
              _buildInfoRow('Active Date', _formatDate(pfData['ActiveDate'])),
              _buildInfoRow('Installments', pfData['NumberOfInstallment']?.toString() ?? '0'),

              const SizedBox(height: 20),

              // PF Amount with highlight
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Text(
                      'Last Month PF Installment Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '৳${pfData['ProvidentFund']?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Additional info or actions
              _buildAdditionalInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';

    try {
      if (date is DateTime) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (date is String) {
        final parsedDate = DateTime.tryParse(date);
        if (parsedDate != null) {
          return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
        }
      }
      return date.toString();
    } catch (e) {
      return 'N/A';
    }
  }

  Widget _buildAdditionalInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '• PF amount is updated monthly\n• Contact Accounts for any discrepancies',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}