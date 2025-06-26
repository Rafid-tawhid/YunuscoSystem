import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_flat_screen.dart';
import 'buildin_screen.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with your Firebase data
    final stats = {
      'buildings': 5,
      'flats': 42,
      'tenants': 38,
      'income': 10,
    };

    final recentPayments = [
      {'flat': 'A-101', 'tenant': 'John Doe', 'amount': 25000, 'date': DateTime.now().subtract(const Duration(days: 1))},
      {'flat': 'B-205', 'tenant': 'Sarah Smith', 'amount': 30000, 'date': DateTime.now().subtract(const Duration(days: 2))},
      {'flat': 'C-302', 'tenant': 'Mike Johnson', 'amount': 28000, 'date': DateTime.now().subtract(const Duration(days: 3))},
    ];

    final occupancyData = {
      'occupied': 32,
      'vacant': 10,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Add refresh functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Summary Cards Row
            _buildStatsRow(stats,context),

            const SizedBox(height: 24),

            // Occupancy Visualization
            _buildOccupancyVisualization(occupancyData),

            const SizedBox(height: 24),

            // Recent Payments
            _buildRecentPaymentsSection(recentPayments),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> stats,BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Row(
      children: [
        Expanded(child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildingManagementScreen()));
          },
          child: _buildStatCard(
            icon: Icons.apartment,
            value: stats['buildings'].toString(),
            label: 'Buildings',
            color: Colors.blue,
          ),
        )),
        const SizedBox(width: 12),
        Expanded(child: InkWell(
          onTap: (){
            //FlatManagementScreen
            Navigator.push(context, MaterialPageRoute(builder: (context)=>FlatManagementScreen()));
          },
          child: _buildStatCard(
            icon: Icons.home_work,
            value: stats['flats'].toString(),
            label: 'Flats',
            color: Colors.purple,
          ),
        )),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(
          icon: Icons.people,
          value: stats['tenants'].toString(),
          label: 'Tenants',
          color: Colors.green,
        )),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(
          icon: Icons.attach_money,
          value: currencyFormat.format(stats['income']),
          label: 'Income',
          color: Colors.amber,
        )),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOccupancyVisualization(Map<String, dynamic> data) {
    final total = data['occupied'] + data['vacant'];
    final occupiedPercent = (data['occupied'] / total * 100).round();
    final vacantPercent = 100 - occupiedPercent;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flat Occupancy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Custom bar visualization
            Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: occupiedPercent / 100,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('Occupied ($occupiedPercent%)'),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('Vacant ($vacantPercent%)'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${data['occupied']} occupied • ${data['vacant']} vacant',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPaymentsSection(List<Map<String, dynamic>> payments) {
    final dateFormat = DateFormat('dd MMM');
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Recent Payments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ...payments.map((payment) => ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Icon(
                    Icons.attach_money,
                    color: Colors.green.shade800,
                  ),
                ),
                title: Text(payment['tenant']),
                subtitle: Text('Flat ${payment['flat']}'),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormat.format(payment['amount']),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dateFormat.format(payment['date']),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )),
              TextButton(
                onPressed: () {
                  // Navigate to payments screen
                },
                child: const Text('VIEW ALL PAYMENTS'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}