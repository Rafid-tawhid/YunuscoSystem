import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BuildingManagementScreen extends StatefulWidget {
  const BuildingManagementScreen({Key? key}) : super(key: key);

  @override
  _BuildingManagementScreenState createState() => _BuildingManagementScreenState();
}

class _BuildingManagementScreenState extends State<BuildingManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _floorsController = TextEditingController();
  final _flatsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _floorsController.dispose();
    _flatsController.dispose();
    super.dispose();
  }

  Future<void> _addBuilding() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _firestore.collection('buildings').add({
        'name': _nameController.text,
        'address': _addressController.text,
        'totalFloors': int.parse(_floorsController.text),
        'totalFlats': int.parse(_flatsController.text),
        'ownerId': _currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _nameController.clear();
      _addressController.clear();
      _floorsController.clear();
      _flatsController.clear();

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Building added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding building: $e')),
      );
    }
  }

  void _showAddBuildingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Building'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Building Name'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _floorsController,
                  decoration: const InputDecoration(labelText: 'Total Floors'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    if (int.tryParse(value!) == null) return 'Enter valid number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _flatsController,
                  decoration: const InputDecoration(labelText: 'Total Flats'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    if (int.tryParse(value!) == null) return 'Enter valid number';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addBuilding,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteBuilding(String buildingId) async {
    try {
      await _firestore.collection('buildings').doc(buildingId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Building deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting building: $e')),
      );
    }
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      label: Text(label),
      avatar: Icon(icon, size: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Building Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddBuildingDialog,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('buildings')
            .where('ownerId', isEqualTo: _currentUser?.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Error loading buildings'),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.data?.docs.isEmpty ?? true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.apartment, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No buildings found'),
                  TextButton(
                    onPressed: _showAddBuildingDialog,
                    child: const Text('Add Your First Building'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final building = snapshot.data!.docs[index];
              final data = building.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(Icons.apartment, size: 40),
                  title: Text(
                    data['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(data['address']),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            icon: Icons.stairs,
                            label: '${data['totalFloors']} Floors',
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            icon: Icons.home,
                            label: '${data['totalFlats']} Flats',
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () {
                          // Implement edit functionality
                          _showEditDialog(building.id, data);
                        },
                      ),
                      PopupMenuItem(
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        onTap: () {
                          _deleteBuilding(building.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBuildingDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditDialog(String buildingId, Map<String, dynamic> data) {
    _nameController.text = data['name'];
    _addressController.text = data['address'];
    _floorsController.text = data['totalFloors'].toString();
    _flatsController.text = data['totalFlats'].toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Building'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Building Name'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _floorsController,
                  decoration: const InputDecoration(labelText: 'Total Floors'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    if (int.tryParse(value!) == null) return 'Enter valid number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _flatsController,
                  decoration: const InputDecoration(labelText: 'Total Flats'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    if (int.tryParse(value!) == null) return 'Enter valid number';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  await _firestore.collection('buildings').doc(buildingId).update({
                    'name': _nameController.text,
                    'address': _addressController.text,
                    'totalFloors': int.parse(_floorsController.text),
                    'totalFlats': int.parse(_flatsController.text),
                  });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Building updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating building: $e')),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}