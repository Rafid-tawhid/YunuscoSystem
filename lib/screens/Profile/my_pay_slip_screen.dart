import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/Profile/widgets/payslip.dart';

import '../../common_widgets/custom_button.dart';

class EmployeePaySlip extends StatefulWidget {
  @override
  _EmployeePaySlipState createState() => _EmployeePaySlipState();
}

class _EmployeePaySlipState extends State<EmployeePaySlip> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  String? _selectedMonth;
  int? _selectedYear;

  Future<void> _selectMonth(BuildContext context) async {
    final List<String> months = DateFormat.MMMM().dateSymbols.MONTHS;

    final String? pickedMonth = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Select Month'),
          content: SizedBox(
            width: double.maxFinite,
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: months.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(months[index]),
                    onTap: () => Navigator.pop(context, months[index]),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (pickedMonth != null) {
      setState(() {
        _selectedMonth = pickedMonth; // Now stores the month name directly
      });
    }
  }

  Future<void> _selectYear(BuildContext context) async {
    final DateTime now = DateTime.now();
    final int currentYear = now.year;
    final List<int> years = List.generate(10, (index) => currentYear - 9 + index);

    final int? picked = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Select Year'),
          content: SizedBox(
            width: double.maxFinite,
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: years.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(years[index].toString()),
                    onTap: () => Navigator.pop(context, years[index]),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedYear = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()&&_selectedMonth!=null&&_selectedYear!=null) {
      var hp=context.read<HrProvider>();

      var data= await hp.getPaySlipInfo(_selectedMonth!,_selectedYear.toString());
      if(data!=null){
        // Navigate to the payslip screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PayslipScreen(
              payslip: data, // Your PayslipModel instance
            ),
          ),
        );
      }
      else {
        DashboardHelpers.showAlert(msg: 'Something went wrong');
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select all field')));
    }
  }


  @override
  void initState() {
    _employeeIdController.text=DashboardHelpers.currentUser!.iDnum??'';
    super.initState();
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Employee Pay Slip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _employeeIdController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Employee ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter employee ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectMonth(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Month',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_view_month),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedMonth == null ? 'Select month' : _selectedMonth??''),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectYear(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Year',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_selectedYear == null ? 'Select year' : _selectedYear.toString()),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Consumer<HrProvider>(
                builder: (context,pro,_)=>CustomElevatedButton(
                  isLoading: pro.isLoading,
                  text: 'Submit',
                  onPressed: _submitForm,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
