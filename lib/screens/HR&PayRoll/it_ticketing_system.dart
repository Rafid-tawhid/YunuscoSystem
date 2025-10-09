import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/ticket_screen.dart';
import 'package:yunusco_group/utils/colors.dart';

class CreateTicketScreen extends StatefulWidget {
  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = Uuid();

  String? _selectedTypes;
  String? _selectedDepartments;
  String? _selectedPriority;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final List<String> _types = ['IT Ticket', 'Maintenance Ticket'];
  final List<String> _departments = [
    'IT Department',
    'Maintenance Department',
    'Production Department',
    'Quality Control',
    'HR Department',
    'Finance Department',
    'Logistics Department',
    'Security Department',
    'Admin Department',
    'Engineering Department'
  ];
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  Future<void> _submitTicket() async {
    if (_formKey.currentState!.validate()) {
      try {
        String token = _uuid.v4().substring(0, 8).toUpperCase();

        Map<String, dynamic> ticketData = {
          'token': token,
          'uId':DashboardHelpers.currentUser!.userId,
          'subject': _subjectController.text,
          'types': _selectedTypes,
          'department': _selectedDepartments,
          'message': _messageController.text,
          'mobile': _mobileController.text,
          'name': _nameController.text,
          'email': _emailController.text,
          'priority': _selectedPriority,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('tickets').doc(token).set(ticketData);

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(content: Text('Ticket submitted successfully! Token: $token',style: TextStyle(color: Colors.white),),backgroundColor: myColors.green,),
        );

        _clearForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting ticket: $e')),
        );
      }
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedTypes = null;
      _selectedPriority = null;
      _selectedDepartments = null;
    });
    _subjectController.clear();
    _messageController.clear();
    _mobileController.clear();
    _nameController.clear();
    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Ticket'),
        backgroundColor: myColors.primaryColor,foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TicketsScreen()));
          }, icon: Icon(Icons.list))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Subject *', _subjectController, Icons.title, true),
                SizedBox(height: 16),
                _buildTypeDropdown(),
                SizedBox(height: 16),
                _buildDepartmentDropdown(),
                SizedBox(height: 16),
                _buildTextField('Message *', _messageController, Icons.message, true, maxLines: 4),
                SizedBox(height: 16),
                _buildTextField('Mobile *', _mobileController, Icons.phone, true, keyboardType: TextInputType.phone),
                SizedBox(height: 16),
                _buildTextField('Name *', _nameController, Icons.person, true),
                SizedBox(height: 16),
                _buildTextField('Email Address *', _emailController, Icons.email, true, keyboardType: TextInputType.emailAddress),
                SizedBox(height: 16),
                _buildPriorityDropdown(),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitTicket,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Submit Ticket', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool isRequired, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        if (label.contains('Email') && value!.isNotEmpty) {
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Enter a valid email';
          }
        }
        if (label.contains('Mobile') && value!.isNotEmpty) {
          if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
            return 'Enter a valid mobile number';
          }
        }
        return null;
      },
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTypes,
      decoration: InputDecoration(
        labelText: 'Types *',
        prefixIcon: Icon(Icons.business),
        border: OutlineInputBorder(),
      ),
      items: _types.map((String department) {
        return DropdownMenuItem<String>(
          value: department,
          child: Text(department),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedTypes = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select types';
        }
        return null;
      },
    );
  }
  Widget _buildDepartmentDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDepartments,
      decoration: InputDecoration(
        labelText: 'Department *',
        prefixIcon: Icon(Icons.business),
        border: OutlineInputBorder(),
      ),
      items: _departments.map((String department) {
        return DropdownMenuItem<String>(
          value: department,
          child: Text(department),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedDepartments = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select department';
        }
        return null;
      },
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPriority,
      decoration: InputDecoration(
        labelText: 'Priority *',
        prefixIcon: Icon(Icons.flag),
        border: OutlineInputBorder(),
      ),
      items: _priorities.map((String priority) {
        return DropdownMenuItem<String>(
          value: priority,
          child: Text(priority),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedPriority = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select priority';
        }
        return null;
      },
    );
  }
}