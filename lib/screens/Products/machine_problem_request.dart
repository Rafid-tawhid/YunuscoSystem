import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/helper_class/firebase_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'dart:convert';

import 'machine_problem_list.dart';

class MachineProblemScreen extends StatefulWidget {
  const MachineProblemScreen({super.key});

  @override
  State<MachineProblemScreen> createState() => _MachineProblemScreenState();
}

class _MachineProblemScreenState extends State<MachineProblemScreen> {
  // Sample data
  final List<Map<String, dynamic>> allProblems = [
    {
      'problem': 'Needle Breakage',
      'problem_code': 'NB001',
      'officer': 'Rajesh Kumar',
      'department': 'Production Line-A',
      'maintenance_person': 'Anil Sharma',
      'skill_required': 'Needle Specialist',
      'duration_min': 15,
      'priority': 'High',
      'description': 'Frequent breaking of needles during operation',
      'solution': 'Replace needle, check alignment, adjust tension'
    },
    {
      'problem': 'Thread Breakage',
      'problem_code': 'TB002',
      'officer': 'Rajesh Kumar',
      'department': 'Production Line-A',
      'maintenance_person': 'Priya Patel',
      'skill_required': 'Threading Expert',
      'duration_min': 20,
      'priority': 'Medium',
      'description': 'Thread breaks frequently during sewing',
      'solution': 'Check thread quality, adjust tension, clean guides'
    },
    {
      'problem': 'Motor Overheating',
      'problem_code': 'MO004',
      'officer': 'Sunita Verma',
      'department': 'Production Line-B',
      'maintenance_person': 'Vikram Singh',
      'skill_required': 'Electrical Engineer',
      'duration_min': 45,
      'priority': 'High',
      'description': 'Motor gets hot and shuts down automatically',
      'solution': 'Clean ventilation, check voltage, lubricate bearings'
    },
    {
      'problem': 'Bobbin Case Jam',
      'problem_code': 'BC005',
      'officer': 'Amit Joshi',
      'department': 'Production Line-C',
      'maintenance_person': 'Anil Sharma',
      'skill_required': 'Mechanical Repair',
      'duration_min': 25,
      'priority': 'Medium',
      'description': 'Bobbin case gets stuck and doesn\'t rotate',
      'solution': 'Clean bobbin area, replace if damaged, check spring'
    },
    {
      'problem': 'Oil Leakage',
      'problem_code': 'OL007',
      'officer': 'Neha Gupta',
      'department': 'Production Line-D',
      'maintenance_person': 'Neha Reddy',
      'skill_required': 'Lubrication Expert',
      'duration_min': 15,
      'priority': 'Low',
      'description': 'Oil leaks from machine during operation',
      'solution': 'Check seals, replace gaskets, clean excess oil'
    },
  ];

  String? selectedProblem;
  Map<String, dynamic>? selectedProblemDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Machine Problem Reporting'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => MachineProblemList()));
              },
              icon: Icon(Icons.list))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Section
             Card(
                color: Colors.white,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Problem',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedProblem,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          hintText: 'Choose a problem',
                          prefixIcon: const Icon(Icons.bug_report_outlined),
                        ),
                        items:
                            allProblems.map<DropdownMenuItem<String>>((problem) {
                          return DropdownMenuItem<String>(
                            value: problem['problem'],
                            child: Text(problem['problem']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedProblem = value;
                            selectedProblemDetails = allProblems.firstWhere(
                              (problem) => problem['problem'] == value,
                            );
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a problem';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),


            const SizedBox(height: 20),

            // Problem Details Section
            if (selectedProblemDetails != null)
              Card(
                elevation: 4,
                color: _getPriorityColor(selectedProblemDetails!['priority']),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getPriorityIcon(
                                selectedProblemDetails!['priority']),
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            selectedProblemDetails!['problem'],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Problem Details
                      _buildDetailRow('Problem Code:',
                          selectedProblemDetails!['problem_code']),
                      _buildDetailRow('Officer In-charge:',
                          selectedProblemDetails!['officer']),
                      _buildDetailRow(
                          'Department:', selectedProblemDetails!['department']),
                      _buildDetailRow('Maintenance Person:',
                          selectedProblemDetails!['maintenance_person']),
                      _buildDetailRow('Skill Required:',
                          selectedProblemDetails!['skill_required']),
                      _buildDetailRow('Estimated Time:',
                          '${selectedProblemDetails!['duration_min']} minutes'),
                      _buildDetailRow(
                          'Priority:', selectedProblemDetails!['priority']),

                      const SizedBox(height: 20),

                      // Description Card
                      Card(
                        color: Colors.white.withOpacity(0.9),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(selectedProblemDetails!['description']),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Solution Card
                      Card(
                        color: Colors.white.withOpacity(0.9),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Suggested Solution:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(selectedProblemDetails!['solution']),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Submit Button
            if (selectedProblemDetails != null)
              Center(
                child: ElevatedButton(
                  onPressed: _submitProblem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.send, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Submit Problem Report',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Empty State
            if (selectedProblemDetails == null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.engineering,
                        size: 100,
                        color: Colors.blueGrey[300],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select a problem from the dropdown\n to view details and submit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red[800]!;
      case 'medium':
        return Colors.orange[800]!;
      case 'low':
        return Colors.blue[800]!;
      default:
        return Colors.blueGrey[800]!;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.error_outline;
      case 'medium':
        return Icons.warning_outlined;
      case 'low':
        return Icons.info_outline;
      default:
        return Icons.help_outline;
    }
  }

  void _submitProblem() {
    if (selectedProblemDetails != null) {
      // Modern Material Design Dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 8,
          title: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                const Icon(Icons.task, color: Colors.blue, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Submit Problem Report',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Problem Summary
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(
                                selectedProblemDetails!['priority']),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            selectedProblemDetails!['priority'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedProblemDetails!['problem'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Assigned to: ${selectedProblemDetails!['maintenance_person']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Confirmation Text
              const Text(
                'Are you sure you want to submit this problem report?',
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),

              const SizedBox(height: 8),

              // Notification Info
              Row(
                children: [
                  Icon(Icons.notifications_active,
                      color: Colors.orange[600], size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Notifications will be sent to concerned staff',
                      style: TextStyle(
                        color: Colors.orange[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('CANCEL'),
            ),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                saveProblemReport();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      );
    }
  }

  //
// Function to save problem report
  Future<void> saveProblemReport() async {
    // Create minimal JSON with essential info only
    Map<String, dynamic> problemReport = {
      // Basic Problem Info
      'problem': selectedProblemDetails!['problem'],
      'problem_code': selectedProblemDetails!['problem_code'],
      'priority': selectedProblemDetails!['priority'],

      // People Involved
      'officer': selectedProblemDetails!['officer'],
      'maintenance_person': selectedProblemDetails!['maintenance_person'],

      // Timestamps
      'reported_at': DateTime.now().toIso8601String(),
      'ticket_id': 'TICKET-${DateTime.now().millisecondsSinceEpoch}',

      // Simple Status
      'status': 'pending',
    };

    // Save/Print
    print('SUBMITTED REPORT: $problemReport');
    FirebaseService firebaseService = FirebaseService();
    var result = await firebaseService.saveMachineProblemReport(problemReport);
    if (result) {
      Navigator.pop(context);
      DashboardHelpers.showSnakBar(
          context: context, message: 'Problem report submitted successfully!');
      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => MachineProblemList()));
      });
    }
  }
}
