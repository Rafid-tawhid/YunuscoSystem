import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> dashboardData = {};
  List<Map<String, dynamic>> unpaidRenters = [];
  List<Map<String, dynamic>> utilityStatus = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final response = await http.get(Uri.parse('YOUR_API_URL/dashboard'));
      if (response.statusCode == 200) {
        setState(() {
          dashboardData = json.decode(response.body);
          unpaidRenters = List<Map<String, dynamic>>.from(
              dashboardData['unpaidRenters'] ?? []);
          utilityStatus = List<Map<String, dynamic>>.from(
              dashboardData['utilityStatus'] ?? []);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Building Management Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchDashboardData,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Monthly Summary Card
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Summary',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatItem('Total Collection',
                                  dashboardData['totalCollection'] ?? 0),
                              _buildStatItem('Total Deduction',
                                  dashboardData['totalDeduction'] ?? 0),
                              _buildStatItem('Current Balance',
                                  dashboardData['currentBalance'] ?? 0),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Empty Flats: ${dashboardData['emptyFlatsCount'] ?? 0}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Utility Payments Status
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Utility Payments Status',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: utilityStatus.map((utility) {
                              return FilterChip(
                                label: Text(utility['name']),
                                selected: utility['paid'],
                                onSelected: (bool value) {
                                  // Handle utility payment toggle
                                },
                                selectedColor: Colors.green,
                                checkmarkColor: Colors.white,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Unpaid Renters List
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unpaid Renters (${unpaidRenters.length})',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(height: 8),
                          unpaidRenters.isEmpty
                              ? Text('All renters have paid for this month')
                              : Column(
                                  children: unpaidRenters.map((renter) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: renter['photoPath'] !=
                                                null
                                            ? NetworkImage(renter['photoPath'])
                                            : AssetImage(
                                                'assets/default_avatar.png'),
                                      ),
                                      title: Text(renter['name']),
                                      subtitle:
                                          Text('Flat: ${renter['flatNumber']}'),
                                      trailing:
                                          Text('\$${renter['dueAmount']}'),
                                      onTap: () {
                                        // Navigate to renter details
                                      },
                                    );
                                  }).toList(),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigate to add building/flat/renter
        },
      ),
    );
  }

  Widget _buildStatItem(String title, dynamic value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(height: 4),
        Text(
          value is num ? '\$${value.toStringAsFixed(2)}' : value.toString(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
