import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TenantManagementScreen extends StatefulWidget {
  @override
  _TenantManagementScreenState createState() => _TenantManagementScreenState();
}

class _TenantManagementScreenState extends State<TenantManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _tenantNameController = TextEditingController();
  final TextEditingController _tenantPhoneController = TextEditingController();
  final TextEditingController _tenantEmailController = TextEditingController();
  DateTime? _moveInDate;
  DateTime? _leaseEndDate;

  Future<void> _addTenant() async {
    if (_tenantNameController.text.isEmpty ||
        _moveInDate == null ||
        _leaseEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      await _firestore.collection('tenants').add({
        'name': _tenantNameController.text,
        'phone': _tenantPhoneController.text,
        'email': _tenantEmailController.text,
        'moveInDate': _moveInDate,
        'leaseEndDate': _leaseEndDate,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Clear form
      _tenantNameController.clear();
      _tenantPhoneController.clear();
      _tenantEmailController.clear();
      setState(() {
        _moveInDate = null;
        _leaseEndDate = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tenant added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding tenant: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isMoveInDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isMoveInDate) {
          _moveInDate = picked;
        } else {
          _leaseEndDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tenant Management')),
      body: Column(
        children: [
          // Add Tenant Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Add New Tenant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _tenantNameController,
                      decoration: InputDecoration(labelText: 'Name*'),
                    ),
                    TextField(
                      controller: _tenantPhoneController,
                      decoration: InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                    ),
                    TextField(
                      controller: _tenantEmailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, true),
                            child: InputDecorator(
                              decoration: InputDecoration(labelText: 'Move-in Date*'),
                              child: Text(_moveInDate == null
                                  ? 'Select date'
                                  : DateFormat('MMM dd, yyyy').format(_moveInDate!)),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, false),
                            child: InputDecorator(
                              decoration: InputDecoration(labelText: 'Lease End Date*'),
                              child: Text(_leaseEndDate == null
                                  ? 'Select date'
                                  : DateFormat('MMM dd, yyyy').format(_leaseEndDate!)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addTenant,
                      child: Text('Add Tenant'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tenant List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('tenants').orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final tenants = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: tenants.length,
                  itemBuilder: (context, index) {
                    final tenant = tenants[index];
                    final data = tenant.data() as Map<String, dynamic>;

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        title: Text(data['name'] ?? 'No Name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['phone'] ?? 'No Phone'),
                            Text('Move-in: ${DateFormat('MMM dd, yyyy').format((data['moveInDate'] as Timestamp).toDate())}'),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TenantPaymentScreen(
                                tenantId: tenant.id,
                                tenantName: data['name'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class TenantPaymentScreen extends StatefulWidget {
  final String tenantId;
  final String tenantName;

  const TenantPaymentScreen({
    required this.tenantId,
    required this.tenantName,
  });

  @override
  _TenantPaymentScreenState createState() => _TenantPaymentScreenState();
}

class _TenantPaymentScreenState extends State<TenantPaymentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  DateTime? _paymentDate;

  Future<void> _addPayment() async {
    if (_amountController.text.isEmpty ||
        _monthController.text.isEmpty ||
        _paymentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      await _firestore.collection('payments').add({
        'tenantId': widget.tenantId,
        'tenantName': widget.tenantName,
        'amount': double.parse(_amountController.text),
        'month': _monthController.text,
        'paymentDate': _paymentDate,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Clear form
      _amountController.clear();
      _monthController.clear();
      setState(() {
        _paymentDate = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding payment: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _paymentDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payments for ${widget.tenantName}')),
      body: Column(
        children: [
          // Add Payment Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Add Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _monthController,
                      decoration: InputDecoration(labelText: 'Month* (e.g., January 2023)'),
                    ),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(labelText: 'Amount*'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(labelText: 'Payment Date*'),
                        child: Text(_paymentDate == null
                            ? 'Select date'
                            : DateFormat('MMM dd, yyyy').format(_paymentDate!)),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addPayment,
                      child: Text('Add Payment'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Payment List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('payments')
                  .where('tenantId', isEqualTo: widget.tenantId)
                  .orderBy('paymentDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final payments = snapshot.data!.docs;

                if (payments.isEmpty) {
                  return Center(child: Text('No payments found'));
                }

                return ListView.builder(
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    final data = payment.data() as Map<String, dynamic>;

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        title: Text('${data['month']} - \$${data['amount']}'),
                        subtitle: Text('Paid on: ${DateFormat('MMM dd, yyyy').format((data['paymentDate'] as Timestamp).toDate())}'),
                        trailing: Text('Paid', style: TextStyle(color: Colors.green)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}