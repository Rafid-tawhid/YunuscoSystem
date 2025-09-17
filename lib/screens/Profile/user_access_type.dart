import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/models/access_type_model.dart';
import 'package:yunusco_group/providers/account_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../providers/hr_provider.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers and values
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userAccessTypeController = TextEditingController();
  String? _selectedUserRole;
  AccessTypeModel? _selectedAccessType; // Changed variable name for clarity

  // Dropdown options
  final List<String> _userRoles = ['Admin', 'Self'];
  bool showRole = true;

  @override
  void initState() {
    super.initState();
    getAccessType();
    getAllStuffMemberList();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var ap = context.read<AccountProvider>();
      var response;
      if (ap.accessList.isNotEmpty && _selectedAccessType != null) {
        response = await ap.saveUserRole(_userIdController.text, _selectedUserRole, _selectedAccessType);
      }
      // Form is valid, process the data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            response['message'].toString(),
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      // You can now use the selected values:
      print('User ID: ${_userIdController.text}');
      print('User Role: $_selectedUserRole');
      print('Access Type ID: ${_selectedAccessType?.accessTypeId}');
      print('Access Type Name: ${_selectedAccessType?.accessTypeName}');
      _userIdController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Access'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User ID Text Field
              Row(
                children: [
                  Expanded(child: Text('')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        setState(() {
                          showRole = !showRole;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            showRole ? 'Role' : 'Access Type',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              showRole
                  ? BuildRoleForm()
                  : Column(
                      children: [
                        TextFormField(
                          controller: _userAccessTypeController,
                          decoration: InputDecoration(
                            labelText: 'Access Type',
                            hintText: 'Enter Access Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a access type';
                            }
                            if (value.length < 3) {
                              return 'Access type must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  var ap = context.read<AccountProvider>();
                                  var resp = await ap.saveUserAccess(_userAccessTypeController.text.trim());
                                  if (resp) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                          'Access Type Created',
                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                  _userAccessTypeController.clear();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: myColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'SAVE',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Consumer<AccountProvider>(
                            builder: (context, pro, _) => Column(
                                  children: pro.accessList
                                      .map((e) => ListTile(
                                            title: Text(e.accessTypeName ?? ''),
                                            subtitle: Text('Created by : ${e.createdBy}'),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  _showDeleteDialog(pro.accessList.indexOf(e), e.accessTypeName ?? '');
                                                },
                                                icon: Icon(Icons.delete)),
                                          ))
                                      .toList(),
                                ))
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Column BuildRoleForm() {
    return Column(
      children: [
        Consumer<HrProvider>(
          builder: (context, pro, _) {
            return TypeAheadField<Map<String, dynamic>>(
              suggestionsCallback: (search) {
                return pro.searchStuffList(search);
              },
              builder: (context, textController, focusNode) {
                return TextFormField(
                  controller: textController, // persistent controller
                  focusNode: focusNode,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'ID is required' : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search Member',
                  ),
                );
              },
              controller: _userIdController,
              //
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion["name"]),
                  subtitle: Text("ID: ${suggestion["id"]}"),
                );
              },
              onSelected: (suggestion) {
                // show ID in the field
                setState(() {
                  _userIdController.text = suggestion["id"];
                });
                FocusScope.of(context).unfocus(); // close keyboard
              },
            );
          },
        ),

        const SizedBox(height: 20),

        // User Role Dropdown
        DropdownButtonFormField<String>(
          value: _selectedUserRole,
          decoration: InputDecoration(
            labelText: 'User Role',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            prefixIcon: const Icon(Icons.assignment_ind),
          ),
          hint: const Text('Select user role'),
          items: _userRoles.map((String role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Text(role),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedUserRole = newValue;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a user role';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        // Access Type Dropdown
        Consumer<AccountProvider>(
          builder: (context, provider, _) {
            // Show loading if data is not loaded yet
            if (provider.accessList.isEmpty) {
              return Container(height: 60, width: 60, child: const CircularProgressIndicator());
            }

            return DropdownButtonFormField<AccessTypeModel>(
              value: _selectedAccessType,
              decoration: InputDecoration(
                labelText: 'Access Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.security),
              ),
              hint: const Text('Select access type'),
              items: provider.accessList.map((AccessTypeModel access) {
                return DropdownMenuItem<AccessTypeModel>(
                  value: access, // Use the current access item
                  child: Text(access.accessTypeName ?? 'Unknown'),
                );
              }).toList(),
              onChanged: (AccessTypeModel? newValue) {
                setState(() {
                  _selectedAccessType = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select an access type';
                }
                return null;
              },
            );
          },
        ),

        const SizedBox(height: 30),

        // Submit Button
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void getAccessType() async {
    final provider = context.read<AccountProvider>();
    await provider.getAccessType();

    // Optional: Set a default value if needed
    if (mounted && provider.accessList.isNotEmpty) {
      setState(() {
        _selectedAccessType = provider.accessList.first;
      });
    }
  }
  Future<void> getAllStuffMemberList() async {
    var hp = context.read<HrProvider>();
    if (hp.member_list.isEmpty) {
      hp.getAllStuffList();
    }
  }

  void _showDeleteDialog(int index, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          itemName: name,
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.itemName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_rounded,
                size: 32,
                color: Colors.red.shade700,
              ),
            ),

            const SizedBox(height: 16),

            // Title
            const Text(
              'Delete Item',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              'Are you sure you want to delete "$itemName"? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.blue.shade700),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),

                const SizedBox(width: 16),

                // Delete button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
