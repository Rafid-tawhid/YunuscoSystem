import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/members_model.dart';
import '../../providers/riverpods/employee_provider.dart';
import '../../providers/riverpods/management_provider.dart';

class CreateAppointmentScreen extends ConsumerStatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  ConsumerState<CreateAppointmentScreen> createState() => _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends ConsumerState<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _purposeController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  MembersModel? _selectedMember;

  @override
  void initState() {
    super.initState();
    // Reset the selected member when screen initializes
    // Future.microtask(() {
    //   ref.read(selectedMemberIdProvider.notifier).state = null;
    // });
    _selectedMember= managementList.first;
  }

  List<MembersModel> managementList=[
    MembersModel.fromJson({
      "IdCardNo": "00004",
      "FullName": "Tahamina Khanam",
      "DesignationName": "Director",
      "DepartmentName": "Management",
      "GradeId": 129,
      "DdlItemName": "A",
      "UserId": 11,
      "UserName": "Tahamina Khanam"
    },),
    MembersModel.fromJson({
      "IdCardNo": "37989",
      "FullName": "Mustainur Raihan",
      "DesignationName": "Chief Operating Officer",
      "DepartmentName": "Management",
      "GradeId": 129,
      "DdlItemName": "A",
      "UserId": 651,
      "UserName": "Mustainur Raihan"
    },),
    MembersModel.fromJson({
      "IdCardNo": "00003",
      "FullName": "Humayun Kabir Ahmed",
      "DesignationName": "Director",
      "DepartmentName": "Management",
      "GradeId": 129,
      "UserId": 000,
      "UserName": "Humayun Kabir Ahmed"
    },),
  ];

  @override
  Widget build(BuildContext context) {
    // final staffListAsync = ref.watch(allStaffListProvider);
    // final selectedMemberId = ref.watch(selectedMemberIdProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: const Text('Create Appointment'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Staff Dropdown
              _buildSectionHeader('Select Management'),
              const SizedBox(height: 8),
            _buildStaffDropdown(managementList, managementList.first.idCardNo),
              // staffListAsync.when(
              //   loading: () => const Center(child: CircularProgressIndicator()),
              //   error: (error, stack) => Container(
              //     padding: const EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.red),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Text(
              //       'Error loading staff: $error',
              //       style: const TextStyle(color: Colors.red),
              //     ),
              //   ),
              //   data: (staffList) {
              //     return _buildStaffDropdown(staffList, selectedMemberId);
              //   },
              // ),

              const SizedBox(height: 24),

              // Date and Time Selection
              _buildSectionHeader('Preferred Date & Time'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimeField(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Purpose TextField
              _buildSectionHeader('Appointment Purpose'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _purposeController,
                decoration: InputDecoration(
                  hintText: 'Enter the purpose of your appointment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter appointment purpose';
                  }
                  if (value.length < 5) {
                    return 'Please provide more details (min. 10 characters)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _submitAppointment(ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create Appointment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),
             if(_selectedMember!=null) _buildAppointmentPreview(ref, _selectedMember!.idCardNo, managementList),
              // Preview Section
              // if (_canShowPreview(selectedMemberId))
              //   _buildAppointmentPreview(ref, selectedMemberId, staffListAsync.value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: myColors.primaryColor,
      ),
    );
  }

  Widget _buildStaffDropdown(List<MembersModel> staffList, String? selectedMemberId) {
    // Find selected member
    // final selectedMember = staffList.firstWhere(
    //       (member) => member.idCardNo == selectedMemberId,
    //   orElse: () => MembersModel(), // Return empty model if not found
    // );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MembersModel>(
          value: staffList.first,
          isExpanded: true,
          hint: const Text('Select management'),
          items: [
            const DropdownMenuItem<MembersModel>(
              value: null,
              child: Text('Select a staff member'),
            ),
            ...staffList.map((member) {
              return DropdownMenuItem<MembersModel>(
                value: member,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      member.fullName ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (member.designationName != null)
                      Text(
                        member.designationName!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
          onChanged: (MembersModel? newValue) {
            setState(() {
              if(newValue!=null){
                _selectedMember=newValue;
              }
            });
           // ref.read(selectedMemberIdProvider.notifier).state = newValue;
          },
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Date *',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate != null
                      ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                      : 'Select Date',
                  style: TextStyle(
                    color: _selectedDate != null ? Colors.black : Colors.grey,
                  ),
                ),
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Time *',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: _selectTime,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime != null
                      ? _selectedTime!.format(context)
                      : 'Select Time',
                  style: TextStyle(
                    color: _selectedTime != null ? Colors.black : Colors.grey,
                  ),
                ),
                const Icon(Icons.access_time, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  bool _canShowPreview(String? selectedMemberId) {
    return selectedMemberId != null ||
        _purposeController.text.isNotEmpty ||
        _selectedDate != null ||
        _selectedTime != null;
  }

  Widget _buildAppointmentPreview(WidgetRef ref, String? selectedMemberId, List<MembersModel>? staffList) {
    final selectedMember = staffList?.firstWhere(
          (member) => member.idCardNo == selectedMemberId,
      orElse: () => MembersModel(),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Appointment Preview:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: myColors.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          if (selectedMemberId != null && selectedMember != null)
            _buildPreviewRow('Staff', '${selectedMember.fullName} (${selectedMember.designationName})'),
          if (_selectedDate != null)
            _buildPreviewRow('Date', DateFormat('MMM dd, yyyy').format(_selectedDate!)),
          if (_selectedTime != null)
            _buildPreviewRow('Time', _selectedTime!.format(context)),
          if (_purposeController.text.isNotEmpty)
            _buildPreviewRow('Purpose', _purposeController.text),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitAppointment(WidgetRef ref) {
    if (_formKey.currentState!.validate()) {

      // Validate all required fields
      if (_selectedMember == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select member'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select both date and time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Get selected member details

      if(_selectedMember!=null){

        // Prepare appointment data

        // final data= {
        //   "employeeName": "Muhammad Amimul Ihsan",
        //   "employeeId": "38682",
        //   "department": "17",
        //   "designation": "Assistant General Manager",
        //   "appointmentWith": "Tahamina Khanam",
        //   "preferredDate": "2025-11-25T00:00:00.000",
        //   "preferredTime": "10:00 AM",
        //   "purpose": "xcxcxcxcxcxcxcxcxcx",
        //   "createdBy": "Muhammad Amimul Ihsan"
        // };

        var  appointmentData = {
          "employeeName": DashboardHelpers.currentUser!.userName,
          "employeeId": DashboardHelpers.currentUser!.iDnum,
          "appointmentNumber": "YBDL-${DateTime.now().millisecondsSinceEpoch}",
          "department": DashboardHelpers.currentUser!.department,
          "designation": DashboardHelpers.currentUser!.designation,
          "appointmentWith": _selectedMember!.fullName,
          "status": "Pending",
          "preferredDate": '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}T00:00:00.000',
          "preferredTime": '${_selectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')} ${_selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}',
          "purpose": _purposeController.text.trim(),
          "createdBy": DashboardHelpers.currentUser!.userName,
        };
        // Create appointment
        _createAppointment(appointmentData);
      }



    }
  }

  String _formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00';
  }

  Future<void> _createAppointment(Map<String, dynamic> data) async {
    // Show loading


    try {
      await createManagementMeeting(ref, data);

      // Optionally check updateProvider state
      final success = ref.read(updateProvider);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment created successfully!')),
        );

        // Clear form and navigate back
        _formKey.currentState!.reset();
        ref.read(selectedMemberIdProvider.notifier).state = null;
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
        });

        Navigator.pop(context);

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }


      // Optionally navigate back after success
      // Navigator.pop(context);

  }

  @override
  void dispose() {
    _purposeController.dispose();
    super.dispose();
  }
}

// Your existing providers (make sure these are in a separate providers file)
final selectedMemberIdProvider = StateProvider<String?>((ref) => null);

final allStaffListProvider = FutureProvider.autoDispose<List<MembersModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);

  final data = await apiService.getData('api/Test/AllEmpData');

  if (data == null) return [];

  List<MembersModel> dataList =
  data.map<MembersModel>((e) => MembersModel.fromJson(e)).toList();

  List<MembersModel> managementList = dataList
      .where((e) => e.departmentName == 'Management')
      .toList();

  debugPrint('managementList ${managementList.length}');
  return managementList;
});