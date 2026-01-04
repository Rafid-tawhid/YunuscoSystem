import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/members_model.dart';

class PersonSelectionScreen extends StatefulWidget {
  bool? forSomeOnesVehicleReq;
  PersonSelectionScreen({super.key, this.forSomeOnesVehicleReq});

  @override
  State<PersonSelectionScreen> createState() => _PersonSelectionScreenState();
}

class _PersonSelectionScreenState extends State<PersonSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<dynamic> _filteredList = [];
  MembersModel? _lastSelectMember;

  @override
  void initState() {
    getAllStuffMemberList();
    super.initState();
    _searchController.addListener(_filterMembers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    final provider = context.read<HrProvider>();

    setState(() {
      _filteredList = provider.member_list.where((person) {
        final name = person.fullName?.toLowerCase() ?? '';
        final department = person.departmentName?.toLowerCase() ?? '';
        final designation = person.designationName?.toLowerCase() ?? '';
        final idCard = person.idCardNo?.toLowerCase() ?? '';

        return name.contains(query) ||
            department.contains(query) ||
            designation.contains(query) ||
            idCard.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,

                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),

                ),
                style: const TextStyle(color: Colors.white),
              )
            : const Text('Select Persons'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Consumer<HrProvider>(
        builder: (context, provider, child) {
          final displayList =
              _isSearching ? _filteredList : provider.member_list;

          return ListView.builder(
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final person = displayList[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: CheckboxListTile(
                    title: Text(person.fullName ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dept: ${person.departmentName}'),
                        Text('Designation: ${person.designationName}'),
                      ],
                    ),
                    value: person.isSelected,
                    onChanged: (bool? value) {
                      // Find the original index in member_list if we're searching
                      final originalIndex =
                          provider.member_list.indexWhere((p) => p == person);
                      if (originalIndex != -1) {
                        provider.toggleSelection(originalIndex);
                      }
                      if (widget.forSomeOnesVehicleReq == true) {
                        _lastSelectMember = person;
                      }
                    },
                    secondary: CircleAvatar(
                      child: Text(person.fullName.toString().substring(0, 1)),
                    )),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.green.shade300),
        ),
        onPressed: () {
          Navigator.pop(context, _lastSelectMember);
        },
        tooltip: 'Save',
        child: const Icon(Icons.check_circle, color: Colors.white),
      ),
    );
  }

  Future<void> getAllStuffMemberList() async {
    var hp = context.read<HrProvider>();
    if (hp.member_list.isEmpty) {
      hp.getAllStuffList();
    }
  }
}
