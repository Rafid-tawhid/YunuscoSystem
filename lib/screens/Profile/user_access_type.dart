import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/access_type_model.dart';
import 'package:yunusco_group/models/user_access_type.dart';
import 'package:yunusco_group/providers/account_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../providers/hr_provider.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userAccessTypeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _selectedUserRole;
  AccessTypeModel? _selectedAccessType;
  final List<String> _userRoles = ['Admin', 'Self'];
  bool _showRoleForm = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _userAccessTypeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    getAccessType();
    await getAllStuffMemberList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Access'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () async {
            getAccessType();
            await getAllStuffMemberList();
          }, icon: Icon(Icons.refresh))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildToggleButton(),
                const SizedBox(height: 12),
                _showRoleForm ? _buildRoleForm() : _buildAccessTypeForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== UI COMPONENTS ==========

  Widget _buildToggleButton() {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () => setState(() => _showRoleForm = !_showRoleForm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _showRoleForm ? 'Role' : 'Access Type',
                style: const TextStyle(color: Colors.white),
              ),
              const Icon(Icons.add, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleForm() {
    return Column(
      children: [
        _buildUserSearchField(),
        const SizedBox(height: 20),
        _buildUserRoleDropdown(),
        const SizedBox(height: 20),
        _buildAccessTypeDropdown(),
        const SizedBox(height: 30),
        _buildSaveButton(
          onPressed: _submitRoleForm,
          text: 'SAVE',
        ),
        const SizedBox(height: 20),
        _buildUserRoleAccessList(),
      ],
    );
  }

  Widget _buildAccessTypeForm() {
    return Column(
      children: [
        _buildAccessTypeTextField(),
        const SizedBox(height: 12),
        _buildSaveButton(
          onPressed: _saveAccessType,
          text: 'SAVE ACCESS TYPE',
        ),
        const SizedBox(height: 12),
        _buildAccessTypeList(),
      ],
    );
  }

  Widget _buildUserSearchField() {
    return Consumer<HrProvider>(
      builder: (context, hrProvider, _) {
        return TypeAheadField<Map<String, dynamic>>(
          suggestionsCallback: (search) => hrProvider.searchStuffList(search),
          builder: (context, textController, focusNode) {
            return TextFormField(
              controller: textController,
              focusNode: focusNode,
              validator: (value) => value == null || value.isEmpty ? 'ID is required' : null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search Member',
              ),
            );
          },
          controller: _userIdController,
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion["name"]),
              subtitle: Text("ID: ${suggestion["id"]}"),
            );
          },
          onSelected: (suggestion) {
            setState(() => _userIdController.text = suggestion["userId"].toString());
            FocusScope.of(context).unfocus();
          },
        );
      },
    );
  }

  Widget _buildUserRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedUserRole,
      decoration: InputDecoration(
        labelText: 'User Role',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        prefixIcon: const Icon(Icons.assignment_ind),
      ),
      hint: const Text('Select user role'),
      items: _userRoles.map((String role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role),
        );
      }).toList(),
      onChanged: (String? newValue) => setState(() => _selectedUserRole = newValue),
      validator: (value) => value == null ? 'Please select a user role' : null,
    );
  }

  Widget _buildAccessTypeDropdown() {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, _) {
        if (accountProvider.accessList.isEmpty) {
          return const SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(),
          );
        }

        return DropdownButtonFormField<AccessTypeModel>(
          value: _selectedAccessType,
          decoration: InputDecoration(
            labelText: 'Access Type',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            prefixIcon: const Icon(Icons.security),
          ),
          hint: const Text('Select access type'),
          items: accountProvider.accessList.map((AccessTypeModel access) {
            return DropdownMenuItem<AccessTypeModel>(
              value: access,
              child: Text(access.accessTypeName ?? 'Unknown'),
            );
          }).toList(),
          onChanged: (AccessTypeModel? newValue) => setState(() => _selectedAccessType = newValue),
          validator: (value) => value == null ? 'Please select an access type' : null,
        );
      },
    );
  }

  Widget _buildAccessTypeTextField() {
    return TextFormField(
      controller: _userAccessTypeController,
      decoration: InputDecoration(
        labelText: 'Access Type',
        hintText: 'Enter Access Type',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        prefixIcon: const Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter a access type';
        if (value.length < 3) return 'Access type must be at least 3 characters';
        return null;
      },
    );
  }

  Widget _buildSaveButton({required VoidCallback onPressed, required String text}) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: myColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildUserRoleAccessList() {
    return Consumer2<AccountProvider, HrProvider>(
      builder: (context, accountProvider, hrProvider, _) {
        final list = accountProvider.userRoleAccess;
        if (list.isEmpty) return const Center(child: Text('No user role access found'));

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final userAccess = list[index];

            final matches = hrProvider.member_list.where(
                  (e) => e.userId == userAccess.userId,
            );
            final member = matches.isNotEmpty ? matches.first : null;

            final displayName = member?.fullName ?? userAccess.userId.toString();

            return ListTile(
              title: Text(displayName),
              subtitle: Text('Role: ${userAccess.role}'),
              trailing: IconButton(
                onPressed: () => _showDeleteDialog(index, userAccess, false),
                icon: const Icon(Icons.delete),
              ),
            );
          },
        );
      },
    );
  }



  Widget _buildAccessTypeList() {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, _) => Column(
        children: accountProvider.accessList
            .map((accessType) => ListTile(
          title: Text(accessType.accessTypeName ?? ''),
          subtitle: Text('Created by : ${accessType.createdBy}'),
          trailing: IconButton(
            onPressed: () => _showDeleteDialog(
              accountProvider.accessList.indexOf(accessType),
              accessType,
              true,
            ),
            icon: const Icon(Icons.delete),
          ),
        ))
            .toList(),
      ),
    );
  }

  // ========== BUSINESS LOGIC ==========

  Future<void> _submitRoleForm() async {
    if (!_formKey.currentState!.validate()) return;

    final accountProvider = context.read<AccountProvider>();
    var response;

    if (accountProvider.accessList.isNotEmpty && _selectedAccessType != null) {
      response = await accountProvider.saveUserRole(
        _userIdController.text,
        _selectedUserRole,
        _selectedAccessType,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          response['Message'].toString(),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    // Add to provider list
    accountProvider.userRoleAccess.add(UserAccessType(
      userId: num.parse(_userIdController.text),
      role: _selectedUserRole,
      accessTypeId: _selectedAccessType?.accessTypeId,
      accessType: _selectedAccessType?.accessTypeName,
    ));
    accountProvider.updateRoleList();
  }

  Future<void> _saveAccessType() async {
    final accountProvider = context.read<AccountProvider>();
    final response = await accountProvider.saveUserAccess(_userAccessTypeController.text.trim());

    if (response['Success']??false) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            response['Message'].toString(),
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 3),
        ),
      );

      // Add to provider list
      accountProvider.accessList.add(AccessTypeModel(
        accessTypeName: _userAccessTypeController.text,
        createdBy: DashboardHelpers.currentUser!.userId.toString(),
      ));
      accountProvider.updateRoleList();
      _userAccessTypeController.clear();
    }



  }

  void getAccessType() async {
    final accountProvider = context.read<AccountProvider>();
    await accountProvider.getAccessType();
    await accountProvider.getUsersWithAccessType();

    if (mounted && accountProvider.accessList.isNotEmpty) {
      setState(() => _selectedAccessType = accountProvider.accessList.first);
    }
  }

  Future<void> getAllStuffMemberList() async {
    final hrProvider = context.read<HrProvider>();
    if (hrProvider.member_list.isEmpty) {
      hrProvider.getAllStuffList();
    }
  }

  void _showDeleteDialog(int index, dynamic model, bool isAccessType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          itemName: isAccessType ? model.accessTypeName : model.userId.toString(),
          onConfirm: () {
            final accountProvider = context.read<AccountProvider>();
            if (isAccessType) {
              accountProvider.deleteAccessType(model);
            } else {
              accountProvider.deleteUserType(model);
            }
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
            const Text(
              'Delete Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to delete "$itemName"? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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