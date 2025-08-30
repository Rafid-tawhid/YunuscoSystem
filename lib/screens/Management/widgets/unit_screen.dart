import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/management_provider.dart';

import '../../../models/JobCardDropdownModel.dart';

class UnitScreen extends StatelessWidget {
  const UnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context
                .read<ManagementProvider>()
                .getAllDropdownInfoForJobcard(),
          ),
        ],
      ),
      body: Consumer<ManagementProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.allDropdownInfoForJobcard!.units!.isEmpty) {
            return const Center(child: Text('No unit found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.allDropdownInfoForJobcard!.units!.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) => SectionTile(
              department: provider.allDropdownInfoForJobcard!.units![index],
              onTap: () => _showDepartmentDetails(
                  context, provider.allDropdownInfoForJobcard!.units![index]),
            ),
          );
        },
      ),
    );
  }

  void _showDepartmentDetails(BuildContext context, Units section) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(section.name ?? 'No Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${section.id}'),
            const SizedBox(height: 8),
            Text('Name: ${section.name}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class SectionTile extends StatelessWidget {
  final Units department;
  final VoidCallback onTap;

  const SectionTile({
    super.key,
    required this.department,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          department.id?.toString() ?? '?',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        department.name ?? 'Unnamed Department',
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
