import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HRPayrollScreen extends StatefulWidget {
  @override
  _HRPayrollScreenState createState() => _HRPayrollScreenState();
}

class _HRPayrollScreenState extends State<HRPayrollScreen> {
  int _currentIndex = 0;
  final List<Employee> employees = [
    Employee(
      id: 'EMP-001',
      name: 'Rahim Mia',
      designation: 'Tailor',
      department: 'Sewing',
      joinDate: DateTime(2022, 1, 15),
      basicSalary: 12000,
      attendance: 26,
      overtimeHours: 8,
    ),
    Employee(
      id: 'EMP-002',
      name: 'Fatema Begum',
      designation: 'Quality Checker',
      department: 'Finishing',
      joinDate: DateTime(2021, 8, 10),
      basicSalary: 15000,
      attendance: 24,
      overtimeHours: 4,
    ),
    // Add more employees
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR & Payroll Management'),
        centerTitle: true,
        backgroundColor: Colors.indigo[800],
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _currentIndex == 0 ? _buildEmployeeList() : _buildPayrollDashboard(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo[800],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Payroll',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[800],
        child: Icon(Icons.add),
        onPressed: _addNewEmployee,
      ),
    );
  }

  Widget _buildEmployeeList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo[100],
              child: Text(employee.id.substring(4)),
            ),
            title: Text(employee.name),
            subtitle: Text('${employee.designation} • ${employee.department}'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildEmployeeDetailRow('Employee ID', employee.id),
                    _buildEmployeeDetailRow('Join Date',
                        DateFormat('dd MMM yyyy').format(employee.joinDate)),
                    _buildEmployeeDetailRow('Basic Salary',
                        '${NumberFormat('#,##0').format(employee.basicSalary)} BDT'),
                    _buildEmployeeDetailRow('Attendance',
                        '${employee.attendance} days'),
                    _buildEmployeeDetailRow('Overtime',
                        '${employee.overtimeHours} hours'),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[800],
                      ),
                      child: Text('Generate Pay Slip'),
                      onPressed: () => _generatePaySlip(employee),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmployeeDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayrollDashboard() {
    final totalEmployees = employees.length;
    final totalSalary = employees.fold<double>(
        0, (sum, emp) => sum + emp.basicSalary);
    final avgAttendance = employees.fold<double>(
        0, (sum, emp) => sum + emp.attendance) / employees.length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Summary Cards
          Row(
            children: [
              _buildSummaryCard('Total Employees', totalEmployees.toString(),
                  Icons.people, Colors.blue),
              SizedBox(width: 12),
              _buildSummaryCard('Monthly Payroll',
                  '${NumberFormat('#,##0').format(totalSalary)} BDT',
                  Icons.attach_money, Colors.green),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildSummaryCard('Avg. Attendance',
                  '${avgAttendance.toStringAsFixed(1)} days',
                  Icons.calendar_today, Colors.orange),
              SizedBox(width: 12),
              _buildSummaryCard('Overtime Hours',
                  '${employees.fold<int>(0, (sum, emp) => sum + emp.overtimeHours)} hrs',
                  Icons.timer, Colors.purple),
            ],
          ),
          SizedBox(height: 24),

          // Payroll Calculation Section
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Salary Calculation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildCalculationRow('Basic Salary', 12000),
                  _buildCalculationRow('Attendance (26 days)', 12000),
                  _buildCalculationRow('Overtime (8 hrs)', 1200),
                  _buildCalculationRow('Bonus', 1500),
                  Divider(height: 24),
                  _buildCalculationRow('Gross Salary', 14700, isTotal: true),
                  _buildCalculationRow('Deductions', 1200),
                  Divider(height: 24),
                  _buildCalculationRow('Net Payable', 13500, isTotal: true),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[800],
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _processPayroll,
                    child: Text('Process Payroll for All'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculationRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? Colors.indigo[800] : Colors.grey[700],
              ),
            ),
          ),
          Text(
            '${NumberFormat('#,##0').format(amount)} BDT',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.indigo[800] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Employees'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('By Department'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => _filterByDepartment(),
            ),
            ListTile(
              title: Text('By Designation'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => _filterByDesignation(),
            ),
            ListTile(
              title: Text('By Salary Range'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => _filterBySalaryRange(),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Reset'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _filterByDepartment() {
    // Implement department filter
    Navigator.pop(context);
  }

  void _filterByDesignation() {
    // Implement designation filter
    Navigator.pop(context);
  }

  void _filterBySalaryRange() {
    // Implement salary range filter
    Navigator.pop(context);
  }

  void _addNewEmployee() {
    // Implement add new employee
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Employee'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Designation'),
              ),
              // Add more fields
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Save'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _generatePaySlip(Employee employee) {
    // Implement pay slip generation
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pay Slip - ${employee.name}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildPaySlipRow('Basic Salary', employee.basicSalary.toDouble()),
            _buildPaySlipRow('Overtime', employee.overtimeHours * 150),
            _buildPaySlipRow('Bonus', 1000),
            Divider(),
            _buildPaySlipRow('Total Earnings',
                employee.basicSalary + (employee.overtimeHours * 150) + 1000),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Print Pay Slip'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaySlipRow(String label, double amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('${NumberFormat('#,##0').format(amount)} BDT'),
        ],
      ),
    );
  }

  void _processPayroll() {
    // Implement payroll processing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payroll processing started for all employees'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class Employee {
  final String id;
  final String name;
  final String designation;
  final String department;
  final DateTime joinDate;
  final int basicSalary;
  final int attendance;
  final int overtimeHours;

  Employee({
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.joinDate,
    required this.basicSalary,
    required this.attendance,
    required this.overtimeHours,
  });
}