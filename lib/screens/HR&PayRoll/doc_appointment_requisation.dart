import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/doc_bottom_sheet.dart';
import '../../common_widgets/custom_button.dart';
import '../../utils/colors.dart';

class DocAppoinmentReq extends StatefulWidget {
  const DocAppoinmentReq({super.key});

  @override
  _DocAppoinmentReqState createState() => _DocAppoinmentReqState();
}

class _DocAppoinmentReqState extends State<DocAppoinmentReq> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
   bool _showSearch=false;

  int? _urgencyType;
  final Map<String, int> _urgencyOptions = {
    'Regular': 1,
    'Emergency': 2,
  };

  @override
  void initState() {
    getAllStuffMemberList();
    super.initState();
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _idController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_urgencyType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select urgency type')),
        );
        return;
      }

      final requestData = {
        "idCardNo": _idController.text,
        "remarks": _remarksController.text,
        "urgencyType": _urgencyType,
        "requestDate": DashboardHelpers.convertDateTime2(DateTime.now()),
        "status": 1,
      };

      var hp = context.read<HrProvider>();
      if (await hp.saveDocAppointment(requestData)) {
        //clear field
        _remarksController.clear();
        if (mounted) {
          DashboardHelpers.showSnakBar(context: context, message: 'Doctor Appointment Success!', bgColor: myColors.green);
        }
        if (mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 8),

              Consumer<HrProvider>(
                builder: (context, pro, _) => Row(
                  children: [
                   if(!pro.showForm) Text(
                      'Found : ${pro.filteredDocAppointmentList.length}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.green.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        pro.showHideDocForm();
                        // Clear search when switching to form
                        if (pro.showForm) {
                          _searchController.clear();
                          pro.clearSearch();
                        }
                      },
                      child: Text(
                        pro.showForm ? 'Requisition List' : 'Create +',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Consumer<HrProvider>(
                        builder: (context, pro, _) => pro.showForm ? DocReqForm() : const SizedBox.shrink(),
                      ),

                      // Appointment List
                      Consumer<HrProvider>(
                        builder: (context, pro, _) {
                          return pro.showForm
                              ? const SizedBox.shrink()
                              : pro.filteredDocAppointmentList.isEmpty
                              ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: _searchController.text.isEmpty
                                  ? const Text('No request yet')
                                  : const Text('No results found'),
                            ),
                          )
                              : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pro.filteredDocAppointmentList.length,
                            itemBuilder: (context, index) {
                              final appointment = pro.filteredDocAppointmentList[index];
                              return Stack(
                                children: [
                                  Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      title: Text('${appointment.fullName} (ID: ${appointment.idCardNo ?? 'N/A'})', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text(
                                            'Serial: ${appointment.serialNo ?? 'N/A'}',
                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                          Text('Date: ${DashboardHelpers.convertDateTime(appointment.createdDate ?? '')}'),
                                          if (appointment.remarks?.isNotEmpty ?? false) Text('Remarks: ${appointment.remarks}'),
                                        ],
                                      ),
                                      onTap: () async {
                                        if (appointment.status == 2) {
                                          var hp = context.read<HrProvider>();
                                          var data = await hp.gatePassDetailsInfo(appointment);
                                          if (data != null) {
                                            showAppointmentBottomSheet(
                                              context: context,
                                              appointment: appointment,
                                              medicineName: data['FullName'] ?? "No Name",
                                              doctorAdvice: data['Advice'] ?? "None",
                                              medicineTime: data["PrescriptionDate"],
                                              leaveNotes: data['Remarks'] ?? "None",
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                 // child: Text(appointment.gatePassStatus.toString()),
                                    child: _buildUrgencyChip(appointment.urgencyType!.toInt(), appointment.gatePassStatus),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: myColors.primaryColor,
      foregroundColor: Colors.white,
      title: _showSearch
          ? Consumer<HrProvider>(
        builder: (context,pro,_)=>TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search by Id or Name...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            pro.searchAppointments(value);
          },
        )
      )
          : const Text('Dr. Appointment'),
      actions: [
        _showSearch
            ? IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            var hp=context.read<HrProvider>();
            hp.clearSearch();
            setState(() {
              _showSearch = false;
              _searchController.clear();

            });
          },
        )
            : IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _showSearch = true;
            });
          },
        ),
      ],
    );
  }
  Widget _buildSearchField(HrProvider pro) {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: 'Search by ID or Name...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
          icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.7)),
          onPressed: () {
            _searchController.clear();
            pro.clearSearch();
            FocusScope.of(context).unfocus();
          },
        )
            : null,
      ),
      onChanged: (value) {
        pro.searchAppointments(value);
      },
    );
  }

  Widget DocReqForm() {
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
                  controller: textController,
                  focusNode: focusNode,
                  validator: (value) => value == null || value.isEmpty ? 'ID is required' : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search Member',
                  ),
                );
              },
              controller: _idController,
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion["name"]),
                  subtitle: Text("ID: ${suggestion["id"]}"),
                );
              },
              onSelected: (suggestion) {
                setState(() {
                  _idController.text = suggestion["id"];
                });
                FocusScope.of(context).unfocus();
              },
            );
          },
        ),
        const SizedBox(height: 16),

        // Urgency Dropdown
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Urgency Type',
            border: OutlineInputBorder(),
          ),
          items: _urgencyOptions.entries
              .map(
                (entry) => DropdownMenuItem<int>(
              value: entry.value,
              child: Text(entry.key),
            ),
          )
              .toList(),
          value: _urgencyType,
          onChanged: (value) => setState(() => _urgencyType = value),
          validator: (_) => _urgencyType == null ? 'Urgency type is required' : null,
        ),
        const SizedBox(height: 16),

        // Remarks Field
        TextFormField(
          controller: _remarksController,
          decoration: const InputDecoration(
            labelText: "Remarks",
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          validator: (value) => value == null || value.isEmpty ? 'Remarks required' : null,
        ),

        const SizedBox(height: 24),

        // Submit Button
        Consumer<HrProvider>(
          builder: (context, pro, _) => CustomElevatedButton(
            isLoading: pro.isLoading,
            text: 'Submit',
            onPressed: _submitForm,
          ),
        ),
      ],
    );
  }

  Widget _buildUrgencyChip(int? urgency, int? gatePass) {
    if (urgency == null) return const SizedBox();

    final bool isApproved = gatePass == 1;

    return Container(
      decoration: BoxDecoration(
        color: isApproved
            ? Colors.green
            : urgency == 1
            ? Colors.orangeAccent
            : Colors.red,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
        child: Text(
          isApproved
              ? 'Approved'
              : urgency == 1
              ? 'Regular'
              : 'Emergency',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
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

class StatusInfo {
  final String text;
  final Color color;

  StatusInfo(this.text, this.color);
}