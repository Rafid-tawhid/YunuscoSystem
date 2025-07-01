import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FlatManagementScreen extends StatefulWidget {
  const FlatManagementScreen({Key? key}) : super(key: key);

  @override
  _FlatManagementScreenState createState() => _FlatManagementScreenState();
}

class _FlatManagementScreenState extends State<FlatManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _flatNumberController = TextEditingController();
  final _floorController = TextEditingController();
  final _rentController = TextEditingController();
  String? _selectedBuildingId;
  String? _selectedStatus = 'vacant';
  DateTime? _moveInDate;
  DateTime? _leaseEndDate;
  final _tenantNameController = TextEditingController();
  final _tenantPhoneController = TextEditingController();
  final _tenantEmailController = TextEditingController();

  List<Map<String, dynamic>> _buildings = [];
  List<Map<String, dynamic>> _flats = [];
  bool _isLoading = false;
  bool _showAddForm = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // Load buildings
      final buildingsSnapshot = await _firestore
          .collection('buildings')
          .where('ownerId', isEqualTo: _currentUser?.uid)
          .get();

      _buildings = buildingsSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] ?? 'Unnamed Building',
        };
      }).toList();

      // Load flats with building names
      final flatsSnapshot = await _firestore
          .collection('flats')
          .where('ownerId', isEqualTo: _currentUser?.uid)
          .get();

      _flats = await Future.wait(flatsSnapshot.docs.map((doc) async {
        final data = doc.data();
        final buildingDoc = await _firestore.collection('buildings').doc(data['buildingId']).get();
        final tenantDoc = data['tenantId'] != null
            ? await _firestore.collection('tenants').doc(data['tenantId']).get()
            : null;

        return {
          'id': doc.id,
          ...data,
          'buildingName': buildingDoc['name'],
          'tenant': tenantDoc?.data(),
        };
      }));

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _saveFlat() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBuildingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a building')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // First save tenant if flat is occupied
      String? tenantId;
      if (_selectedStatus == 'occupied') {
        final tenantDoc = await _firestore.collection('tenants').add({
          'name': _tenantNameController.text,
          'phone': _tenantPhoneController.text,
          'email': _tenantEmailController.text,
          'moveInDate': _moveInDate,
          'leaseEndDate': _leaseEndDate,
          'createdAt': FieldValue.serverTimestamp(),
        });
        tenantId = tenantDoc.id;
      }

      // Then save flat
      await _firestore.collection('flats').add({
        'buildingId': _selectedBuildingId,
        'ownerId': _currentUser?.uid,
        'flatNumber': _flatNumberController.text,
        'floor': int.parse(_floorController.text),
        'monthlyRent': double.parse(_rentController.text),
        'status': _selectedStatus,
        'tenantId': tenantId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flat added successfully')),
      );
      _resetForm();
      await _loadData(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving flat: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _showAddForm = false;
      });
    }
  }

  void _resetForm() {
    _flatNumberController.clear();
    _floorController.clear();
    _rentController.clear();
    _tenantNameController.clear();
    _tenantPhoneController.clear();
    _tenantEmailController.clear();
    _selectedBuildingId = null;
    _selectedStatus = 'vacant';
    _moveInDate = null;
    _leaseEndDate = null;
  }

  Future<void> _selectDate(BuildContext context, bool isMoveInDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isMoveInDate) {
          _moveInDate = picked;
          if (_leaseEndDate == null || _leaseEndDate!.isBefore(picked)) {
            _leaseEndDate = picked.add(const Duration(days: 365));
          }
        } else {
          _leaseEndDate = picked;
        }
      });
    }
  }

  Widget _buildFlatList() {
    if (_flats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No flats found'),
            ElevatedButton(
              onPressed: () => setState(() => _showAddForm = true),
              child: const Text('Add New Flat'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _flats.length,
      itemBuilder: (context, index) {
        final flat = _flats[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: const Icon(Icons.apartment, size: 40),
            title: Text('${flat['flatNumber']} (Floor ${flat['floor']})'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Building: ${flat['buildingName']}'),
                Text('Rent: ₹${flat['monthlyRent']}'),
                Text('Status: ${flat['status']}'),
                if (flat['tenant'] != null) ...[
                  const SizedBox(height: 8),
                  const Text('Tenant:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Name: ${flat['tenant']['name']}'),
                  Text('Phone: ${flat['tenant']['phone']}'),
                  Text('Email: ${flat['tenant']['email']}'),
                  Text('Lease: ${DateFormat('dd MMM yyyy').format(flat['tenant']['moveInDate'].toDate())} - ${DateFormat('dd MMM yyyy').format(flat['tenant']['leaseEndDate'].toDate())}'),
                ],
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Implement edit functionality
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Building Selection
            DropdownButtonFormField<String>(
              value: _selectedBuildingId,
              decoration: const InputDecoration(
                labelText: 'Building',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: _buildings.isNotEmpty
                  ? _buildings.map<DropdownMenuItem<String>>((building) {
                return DropdownMenuItem<String>(
                  value: building['id']?.toString(), // Ensure non-null String value
                  child: Text(building['name']?.toString() ?? 'Unnamed Building'),
                );
              }).toList()
                  : [ // Fallback for empty buildings list
                const DropdownMenuItem<String>(
                  value: null,
                  enabled: false,
                  child: Text('No buildings available'),
                )
              ],
              onChanged: _buildings.isNotEmpty
                  ? (String? newValue) {
                setState(() {
                  _selectedBuildingId = newValue;
                });
              }
                  : null, // Disable dropdown if no buildings
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a building';
                }
                return null;
              },
              isExpanded: true, // Takes full width
              hint: const Text('Select a building'),
              disabledHint: const Text('No buildings available'),
            ),
            const SizedBox(height: 16),

            // Flat Number
            TextFormField(
              controller: _flatNumberController,
              decoration: const InputDecoration(
                labelText: 'Flat Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Floor
            TextFormField(
              controller: _floorController,
              decoration: const InputDecoration(
                labelText: 'Floor',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                if (int.tryParse(value!) == null) return 'Enter valid number';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Monthly Rent
            TextFormField(
              controller: _rentController,
              decoration: const InputDecoration(
                labelText: 'Monthly Rent',
                border: OutlineInputBorder(),
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                if (double.tryParse(value!) == null) return 'Enter valid amount';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Status
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'vacant',
                  child: Text('Vacant'),
                ),
                DropdownMenuItem(
                  value: 'occupied',
                  child: Text('Occupied'),
                ),
              ],
              onChanged: (value) => setState(() => _selectedStatus = value),
            ),
            const SizedBox(height: 16),

            // Tenant Details (only shown if status is occupied)
            if (_selectedStatus == 'occupied') ...[
              const Text(
                'Tenant Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _tenantNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _tenantPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _tenantEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Move-in Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _moveInDate != null
                              ? DateFormat('dd MMM yyyy').format(_moveInDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Lease End Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _leaseEndDate != null
                              ? DateFormat('dd MMM yyyy').format(_leaseEndDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null :  _saveFlat,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save Flat'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                      _resetForm();
                      setState(() => _showAddForm = false);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flat Management'),
        actions: [
          if (!_showAddForm)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() {
                _resetForm();
                _showAddForm = true;
              }),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _showAddForm ? _buildAddForm() : _buildFlatList(),
      floatingActionButton: !_showAddForm && _flats.isNotEmpty
          ? FloatingActionButton(
        onPressed: () => setState(() {
          _resetForm();
          _showAddForm = true;
        }),
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}