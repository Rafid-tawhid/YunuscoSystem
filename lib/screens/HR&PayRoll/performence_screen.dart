import 'package:flutter/material.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/search_emp_bottomsheet.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import 'package:flutter/material.dart';

import '../../models/members_model.dart';

class PerformanceEvaluationScreen extends StatefulWidget {
  @override
  _PerformanceEvaluationScreenState createState() =>
      _PerformanceEvaluationScreenState();
}

class _PerformanceEvaluationScreenState
    extends State<PerformanceEvaluationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();
  final TextEditingController _empId = TextEditingController();
  MembersModel? selectedEmp;

  final Map<String, double> _ratings = {
    'Quality of Work': 3.0,
    'Productivity': 3.0,
    'Technical Skills': 3.0,
    'Communication': 3.0,
    'Teamwork': 3.0,
    'Problem Solving': 3.0,
    'Initiative': 3.0,
    'Attendance': 3.0,
    'Adaptability': 3.0,
    'Leadership': 3.0,
  };

  String _overallRating = 'Satisfactory';
  Color _overallRatingColor = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Weekly Performance Evaluation'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmployeeInfoSection(),
              SizedBox(height: 24),
              _buildEvaluationCriteriaSection(),
              SizedBox(height: 24),
              _buildOverallRatingSection(),
              SizedBox(height: 24),
              _buildCommentsSection(),
              SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeInfoSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Employee Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => EmployeeSearchBottomSheet(
                    onEmployeeSelected: (selectedEmployee) {
                      setState(() {
                        debugPrint('selectedEmployee ${selectedEmployee.idCardNo}');
                        _empId.text=selectedEmployee.idCardNo??'';
                        selectedEmp=selectedEmployee;
                      });

                    },
                  ),
                );
              },
              child: _buildTextFormField(
                controller: _empId,
                label: 'Employee Id',
                isEnable: false,
                isRequired: true,
              ),
            ),

            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationCriteriaSection() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Criteria',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Rate each category from 1 (Needs Improvement) to 5 (Excellent)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            ..._ratings.keys.map((criterion) => _buildRatingSlider(criterion)),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSlider(String criterion) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                criterion,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${_ratings[criterion]!.toStringAsFixed(1)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getRatingColor(_ratings[criterion]!),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Slider(
            value: _ratings[criterion]!,
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: (value) {
              setState(() {
                _ratings[criterion] = value;
                _calculateOverallRating();
              });
            },
            activeColor: _getRatingColor(_ratings[criterion]!),
            inactiveColor: Colors.grey[300],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1 - Needs Improvement', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('5 - Excellent', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverallRatingSection() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Rating',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _overallRatingColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _overallRatingColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Performance Level:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _overallRating,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _overallRatingColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildTextFormField(
              controller: _goalsController,
              label: 'Goals for Next Period',
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _commentsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter additional comments, strengths, and areas for improvement...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [

        Expanded(
          child: ElevatedButton(
            onPressed: _submitEvaluation,
            style: ElevatedButton.styleFrom(
              backgroundColor: myColors.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Submit Evaluation', style: TextStyle(fontSize: 16,color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    bool isEnable = true,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      enabled: isEnable,
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      validator: isRequired
          ? (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      }
          : null,
    );
  }

  Color _getRatingColor(double rating) {
    if (rating < 2) return Colors.red;
    if (rating < 3) return Colors.orange;
    if (rating < 4) return Colors.yellow[700]!;
    return Colors.green;
  }

  void _calculateOverallRating() {
    double average = _ratings.values.reduce((a, b) => a + b) / _ratings.length;

    if (average < 2) {
      _overallRating = 'Unsatisfactory';
      _overallRatingColor = Colors.red;
    } else if (average < 3) {
      _overallRating = 'Needs Improvement';
      _overallRatingColor = Colors.orange;
    } else if (average < 4) {
      _overallRating = 'Satisfactory';
      _overallRatingColor = Colors.yellow[700]!;
    } else if (average < 4.5) {
      _overallRating = 'Good';
      _overallRatingColor = Colors.lightGreen;
    } else {
      _overallRating = 'Excellent';
      _overallRatingColor = Colors.green;
    }
  }

  void _submitEvaluation() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically save the evaluation to your database
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Evaluation Submitted'),
            content: Text('Performance evaluation has been successfully submitted.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Optionally reset the form or navigate away
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _saveAsDraft() {
    // Save evaluation as draft
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Evaluation saved as draft'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _calculateOverallRating();
  }
}
