import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/management_provider.dart';

import '../../../models/JobCardDropdownModel.dart';

class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ManagementProvider>().getAllDropdownInfoForJobcard(),
          ),
        ],
      ),
      body: Consumer<ManagementProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.allDropdownInfoForJobcard!.departments!.isEmpty) {
            return const Center(child: Text('No departments found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.allDropdownInfoForJobcard!.departments!.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) => DepartmentTile(
              department: provider.allDropdownInfoForJobcard!.departments![index],
              onTap: () => _showDepartmentDetails(context, provider.allDropdownInfoForJobcard!.departments![index]),
            ),
          );
        },
      ),
    );
  }

  void _showDepartmentDetails(BuildContext context, Departments department) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(department.name ?? 'No Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${department.id}'),
            const SizedBox(height: 8),
            Text('Name: ${department.name}'),
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

class DepartmentTile extends StatelessWidget {
  final Departments department;
  final VoidCallback onTap;

  const DepartmentTile({
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