import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/screens/Products/Machine/machine_qr_scanner.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../helper_class/dashboard_helpers.dart';
import '../../../models/machine_breakdown_model.dart';
import '../../../providers/riverpods/production_provider.dart';
import 'machine_repair_screen.dart';
import 'multiple_machine_repair_list.dart';

class MachineBreakdownListScreen extends ConsumerWidget {
  const MachineBreakdownListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdownsAsync = ref.watch(machineBreakdownListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Machine Breakdown List'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MachineMultipleProblemRequestScreen()));
            },
            tooltip: 'Setup',
          ),
          // IconButton(
          //   icon: const Icon(Icons.qr_code_scanner),
          //   onPressed: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>BeautifulQRScannerScreen()));
          //   },
          //   tooltip: 'Refresh',
          // ),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(machineBreakdownListProvider);
          },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: breakdownsAsync.when(
                data: (breakdowns) {
                  if (breakdowns.isEmpty) {
                    return const Center(
                      child: Text('No machine breakdowns found.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: breakdowns.length,
                    itemBuilder: (context, index) {
                      final breakdown = breakdowns[index];

                      return MachineBreakdownCard(breakdown: breakdown);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error loading data: $error'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Machine Problem Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColors.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>BeautifulQRScannerScreen()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



}




class MachineBreakdownCard extends StatelessWidget {
  final MachineBreakdownModel breakdown;
  final VoidCallback? onTap;
  final Color backgroundColor;

  const MachineBreakdownCard({
    super.key,
    required this.breakdown,
    this.onTap,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // Determine card color based on status
    final Color cardColor = _getCardColor(breakdown.status ?? 0);
    final Color textColor = _getTextColor(breakdown.status ?? 0);
    final bool isEditable = breakdown.status != 2; // No edit if status is 2 (Resolved)
    final bool isResolved = breakdown.status == 2; // Status 2 means Resolved

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blue.withOpacity(0.1),
        highlightColor: Colors.blue.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Machine Name and Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  _buildStatusBadge(breakdown.status ?? 0),
                  const SizedBox(width: 12),

                  // Machine Name and Edit Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (breakdown.machineName != null && breakdown.machineName!.isNotEmpty)
                          Text(
                            breakdown.machineName!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),

                  // Edit Button (Only if editable - not resolved)
                  if (isEditable)
                    _buildEditButton(context),
                ],
              ),

              const SizedBox(height: 12),

              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Requisition Code
                  if (breakdown.requisitionCode != null && breakdown.requisitionCode!.isNotEmpty)
                    _buildDetailRow(
                      icon: Icons.qr_code,
                      label: 'Requisition',
                      value: breakdown.requisitionCode!,
                      textColor: textColor,
                    ),

                  // Location
                  if (breakdown.sectionName != null || breakdown.lineName != null)
                    _buildDetailRow(
                      icon: Icons.location_on,
                      label: 'Line No',
                      value: '${breakdown.sectionName ?? ''}${breakdown.lineName != null ? '${breakdown.lineName!}' : ''}',
                      textColor: textColor,
                    ),

                  // Maintenance Type

                  if (breakdown.maintenanceName != null && breakdown.maintenanceName!.isNotEmpty)
                    _buildDetailRow(
                      icon: Icons.build,
                      label: 'Maintenance',
                      value: breakdown.maintenanceName!,
                      textColor: textColor,
                    ),
                  // Machine Type
                  if (breakdown.swingMachineTypeName != null && breakdown.swingMachineTypeName!.isNotEmpty)
                    _buildDetailRow(
                      icon: Icons.category,
                      label: 'Type',
                      value: breakdown.swingMachineTypeName!,
                      textColor: textColor,
                    ),

                  // Created Date
                  if (breakdown.createdDate != null && breakdown.createdDate!.isNotEmpty)
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      label: 'Reported',
                      value: DashboardHelpers.convertDateTime(breakdown.createdDate!),
                      textColor: textColor,
                    ),

                  // If resolved, show resolved date (check if resolvedDate exists)
                  if (isResolved)
                    _buildDetailRow(
                      icon: Icons.check_circle,
                      label: 'Resolved',
                      value: DashboardHelpers.convertDateTime(breakdown.createdDate!),
                      textColor: textColor,
                      iconColor: Colors.green,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods
  Color _getCardColor(int status) {
    switch (status) {
      case 2: // Resolved - Green
        return Colors.green.shade50;
      case 1: // In Progress - Orange
        return Colors.orange.shade50;
      default: // Pending/Open - Red (status 0 or other)
        return Colors.red.shade50;
    }
  }

  Color _getTextColor(int status) {
    switch (status) {
      case 2: // Resolved
        return Colors.green.shade900;
      case 1: // In Progress
        return Colors.orange.shade900;
      default: // Pending/Open
        return Colors.red.shade900;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 2:
        return 'RESOLVED';
      case 1:
        return 'IN PROGRESS';
      default:
        return 'PENDING';
    }
  }

  Widget _buildStatusBadge(int status) {
    final Color badgeColor;
    final Color textColor;

    switch (status) {
      case 2: // Resolved
        badgeColor = Colors.green;
        textColor = Colors.white;
        break;
      case 1: // In Progress
        badgeColor = Colors.orange;
        textColor = Colors.white;
        break;
      default: // Pending/Open
        badgeColor = Colors.red;
        textColor = Colors.white;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MachineProblemRequestScreen(
              breakdownModel: breakdown,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.deepOrange.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.edit,
          size: 18,
          color: Colors.deepOrange,
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: iconColor ?? textColor.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
