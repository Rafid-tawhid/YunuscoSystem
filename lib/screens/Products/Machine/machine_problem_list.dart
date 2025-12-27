// lib/screens/machine_breakdown_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/common_widgets/custom_button.dart';
import 'package:yunusco_group/screens/Products/Machine/machine_qr_scanner.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../helper_class/dashboard_helpers.dart';
import '../../../models/machine_breakdown_model.dart';
import '../../../providers/riverpods/production_provider.dart';
import 'machine_problem_request.dart';
import 'machine_repair_screen.dart';

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

              Navigator.push(context, MaterialPageRoute(builder: (context)=>MachineProblemRequestScreen()));
            },
            tooltip: 'Setup',
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BeautifulQRScannerScreen()));
            },
            tooltip: 'Refresh',
          ),
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Machine Name
              if (breakdown.machineName != null && breakdown.machineName!.isNotEmpty)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        breakdown.machineName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(),
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MachineProblemRequestScreen(breakdownModel: breakdown,)));
                    }, icon: Icon(Icons.edit))
                  ],
                ),

              // Requisition Code
              if (breakdown.requisitionCode != null && breakdown.requisitionCode!.isNotEmpty)
                _buildRow('Requisition:', breakdown.requisitionCode!),

              // Location
              if (breakdown.sectionName != null || breakdown.lineName != null)
                _buildRow(
                  'Location:',
                  '${breakdown.sectionName ?? ''}${breakdown.lineName != null ? ' - ${breakdown.lineName!}' : ''}',
                ),

              // Maintenance
              if (breakdown.maintenanceName != null && breakdown.maintenanceName!.isNotEmpty)
                _buildRow('Maintenance:', breakdown.maintenanceName!),

              // Machine Type
              if (breakdown.swingMachineTypeName != null && breakdown.swingMachineTypeName!.isNotEmpty)
                _buildRow('Type:', breakdown.swingMachineTypeName!),

              // Date
              if (breakdown.createdDate != null && breakdown.createdDate!.isNotEmpty)
                _buildRow('Date:', DashboardHelpers.convertDateTime(breakdown.createdDate!)),

            ],
          ),
        ),
      ),
    );
  }



  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
