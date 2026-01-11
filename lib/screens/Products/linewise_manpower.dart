import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../providers/riverpods/production_provider.dart';

class LinewiseManpowerScreen extends ConsumerWidget {
  const LinewiseManpowerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ensure this provider exists in your production_provider.dart
    final manpowerAsync = ref.watch(lineWiseManPower); // Fixed naming convention

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Linewise Manpower'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){
            ref.invalidate(lineWiseManPower);
          }, icon: Icon(Icons.refresh))
        ],
      ),
      body: manpowerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: ${err.toString()}')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                'No data found',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final item = list[index];

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Line: ${item.lineNo ?? 'N/A'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem('Operator', item.operator ?? 0),
                          _buildStatItem('Helper', item.helper ?? 0),
                          _buildTotalItem('Total', item.total ?? 0),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, num? value) {
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
        Text(
          value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalItem(String label, num? value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue[700],
          ),
        ),
      ],
    );
  }
}

