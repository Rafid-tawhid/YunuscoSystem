import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import '../../../models/members_model.dart';
import '../../../providers/riverpods/employee_provider.dart';

class EmployeeSearchBottomSheet extends ConsumerStatefulWidget {
  final Function(MembersModel) onEmployeeSelected;

  const EmployeeSearchBottomSheet({
    super.key,
    required this.onEmployeeSelected,
  });

  @override
  ConsumerState<EmployeeSearchBottomSheet> createState() => _EmployeeSearchBottomSheetState();
}

class _EmployeeSearchBottomSheetState extends ConsumerState<EmployeeSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<MembersModel> _filteredStaffList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(staffProvider.notifier).getAllStaffList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterStaff(String query) {
    final staffList = ref.read(staffProvider); // Get the current staff list

    if (query.isEmpty) {
      setState(() {
        _filteredStaffList = staffList; // Show full list when query is empty
      });
    } else {
      setState(() {
        _filteredStaffList = staffList.where((staff) {
          return staff.fullName?.toLowerCase().contains(query.toLowerCase()) == true ||
              staff.idCardNo?.toLowerCase().contains(query.toLowerCase()) == true;
        }).toList();
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _filterStaff('');
  }

  @override
  Widget build(BuildContext context) {
    final staffList = ref.watch(staffProvider); // Watch for changes in staff list

    // Update filtered list when staffList changes
    if (_filteredStaffList.isEmpty && staffList.isNotEmpty) {
      _filteredStaffList = staffList;
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Employee',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or ID...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
                  onPressed: _clearSearch,
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _filterStaff,
            ),
          ),

          // Results count
          if (_filteredStaffList.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${_filteredStaffList.length} employee(s) found',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 8),

          // Employee List or Empty State
          Expanded(
            child: _buildContent(staffList),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<MembersModel> staffList) {
    // Show loading if list is empty and no search
    if (staffList.isEmpty && _searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading employees...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Show no data found when search has no results
    if (_filteredStaffList.isEmpty && _searchController.text.isNotEmpty) {
      return _buildEmptyState(true);
    }

    // Show no employees available when list is empty
    if (_filteredStaffList.isEmpty) {
      return _buildEmptyState(false);
    }

    // Show the filtered list
    return ListView.separated(
      itemCount: _filteredStaffList.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final staff = _filteredStaffList[index];
        return _buildEmployeeItem(staff);
      },
    );
  }

  Widget _buildEmployeeItem(MembersModel staff) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(
          DashboardHelpers.getFistAndLastNmaeByFullName(staff.fullName??''),
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        staff.fullName ?? 'No Name',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (staff.departmentName != null)
            Text(
              staff.departmentName!,
              style: TextStyle(fontSize: 14),
            ),
          if (staff.idCardNo != null)
            Text(
              'ID: ${staff.idCardNo!}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        widget.onEmployeeSelected(staff);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildEmptyState(bool isSearch) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearch ? Icons.search_off : Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            isSearch ? 'No employees found' : 'No employees available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            isSearch
                ? 'Try searching with different keywords'
                : 'Employee list is empty',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (isSearch)
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: ElevatedButton.icon(
                onPressed: _clearSearch,
                icon: Icon(Icons.clear_all),
                label: Text('Clear Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }


}