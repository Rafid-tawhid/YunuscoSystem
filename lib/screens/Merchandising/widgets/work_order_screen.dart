import 'package:flutter/material.dart';

class WOScreen extends StatefulWidget {
  const WOScreen({super.key});

  @override
  State<WOScreen> createState() => _WOScreenState();
}

class _WOScreenState extends State<WOScreen> {
  // Sample work order data - replace with your actual data source
  final List<WorkOrder> workOrders = [
    WorkOrder(
      id: 'WO-1001',
      title: 'Machine Maintenance',
      priority: 'High',
      status: 'In Progress',
      assignedTo: 'John Doe',
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    WorkOrder(
      id: 'WO-1002',
      title: 'Equipment Calibration',
      priority: 'Medium',
      status: 'Pending',
      assignedTo: 'Jane Smith',
      dueDate: DateTime.now().add(const Duration(days: 5)),
    ),
    WorkOrder(
      id: 'WO-1003',
      title: 'Safety Inspection',
      priority: 'Low',
      status: 'Completed',
      assignedTo: 'Mike Johnson',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  String _currentFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filteredOrders = workOrders.where((order) {
      final matchesFilter = _currentFilter == 'All' ||
          order.status == _currentFilter;
      final matchesSearch = order.title.toLowerCase().contains(
          _searchController.text.toLowerCase()) ||
          order.id.toLowerCase().contains(
              _searchController.text.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search work orders...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Status filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Pending', 'In Progress', 'Completed']
                  .map((filter) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  label: Text(filter),
                  selected: _currentFilter == filter,
                  onSelected: (selected) {
                    setState(() {
                      _currentFilter = selected ? filter : 'All';
                    });
                  },
                ),
              ))
                  .toList(),
            ),
          ),

          // Work order list
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return _buildWorkOrderCard(order);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateWO,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWorkOrderCard(WorkOrder order) {
    Color statusColor = Colors.grey;
    if (order.status == 'In Progress') statusColor = Colors.orange;
    if (order.status == 'Completed') statusColor = Colors.green;
    if (order.status == 'Pending' && order.priority == 'High') {
      statusColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.work, size: 36),
        title: Text(order.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('WO#: ${order.id}'),
            Text('Assigned to: ${order.assignedTo}'),
            Text('Due: ${_formatDate(order.dueDate)}'),
          ],
        ),
        trailing: Chip(
          label: Text(
            order.status,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: statusColor,
        ),
        onTap: () => _navigateToWODetail(order),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToWODetail(WorkOrder order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WODetailScreen(workOrder: order),
      ),
    );
  }

  void _navigateToCreateWO() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateWOScreen(),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Advanced Filters'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add more filter options here
              const Text('Priority:'),
              Wrap(
                children: ['All', 'High', 'Medium', 'Low']
                    .map((priority) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(priority),
                    selected: false, // Implement actual selection
                    onSelected: (selected) {
                      // Implement priority filtering
                    },
                  ),
                ))
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// Work Order Model
class WorkOrder {
  final String id;
  final String title;
  final String priority;
  final String status;
  final String assignedTo;
  final DateTime dueDate;

  WorkOrder({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    required this.assignedTo,
    required this.dueDate,
  });
}

// Work Order Detail Screen
class WODetailScreen extends StatelessWidget {
  final WorkOrder workOrder;

  const WODetailScreen({super.key, required this.workOrder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WO# ${workOrder.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(workOrder.title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            _buildDetailRow('Status', workOrder.status),
            _buildDetailRow('Priority', workOrder.priority),
            _buildDetailRow('Assigned To', workOrder.assignedTo),
            _buildDetailRow('Due Date',
                '${workOrder.dueDate.day}/${workOrder.dueDate.month}/${workOrder.dueDate.year}'),
            const SizedBox(height: 30),
            const Text('Description:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('Full details of the work order would appear here...'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement action (complete, reassign, etc.)
                },
                child: const Text('Mark as Complete'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(value),
        ],
      ),
    );
  }
}

// Create Work Order Screen
class CreateWOScreen extends StatelessWidget {
  const CreateWOScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Work Order'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Work order creation form would go here...'),
      ),
    );
  }
}