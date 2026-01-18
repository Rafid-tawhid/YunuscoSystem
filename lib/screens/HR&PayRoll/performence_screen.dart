import 'package:flutter/material.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/employee_performance_list.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/search_emp_bottomsheet.dart';
import 'package:yunusco_group/service_class/api_services.dart';
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
  final TextEditingController _weekController = TextEditingController();
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
  void initState() {
    super.initState();
    _calculateOverallRating();
    _setDefaultWeek();
  }

  void _setDefaultWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    _weekController.text = '${_formatDate(startOfWeek)} - ${_formatDate(endOfWeek)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Weekly Performance Evaluation'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PerformanceRatingsScreen()));
          }, icon: Icon(Icons.list))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildWeekSelectionSection(),
              SizedBox(height: 16),
              _buildEmployeeInfoSection(),
              SizedBox(height: 24),
              _buildEvaluationCriteriaSection(),
              SizedBox(height: 24),
              _buildOverallRatingSection(),
              SizedBox(height: 24),
              _buildWeeklyCommentsSection(),
              SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekSelectionSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evaluation Week',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 12),
            _buildTextFormField(
              controller: _weekController,
              label: 'Week Period (DD/MM/YYYY - DD/MM/YYYY)',
              isRequired: true,
            ),
            SizedBox(height: 8),
            Text(
              'This evaluation covers performance for the selected week',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => EmployeeSearchBottomSheet(
                    onEmployeeSelected: (selectedEmployee) {
                      setState(() {
                        debugPrint('selectedEmployee ${selectedEmployee.idCardNo}');
                        _empId.text = selectedEmployee.idCardNo ?? '';
                        selectedEmp = selectedEmployee;
                      });
                    },
                  ),
                );
              },
              child: _buildTextFormField(
                controller: _empId,
                label: 'Employee ID',
                isEnable: false,
                isRequired: true,
              ),
            ),
            SizedBox(height: 12),
            if (selectedEmp != null) _buildSelectedEmployeeInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedEmployeeInfo() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(
              _getInitials(selectedEmp!.fullName ?? 'N/A'),
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedEmp!.fullName ?? 'No Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (selectedEmp!.departmentName != null)
                  Text(
                    selectedEmp!.departmentName!,
                    style: TextStyle(fontSize: 14),
                  ),
                if (selectedEmp!.designationName != null)
                  Text(
                    selectedEmp!.designationName!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
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
              'Weekly Performance Criteria',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Rate each category from 1 (Needs Improvement) to 5 (Excellent) based on this week\'s performance',
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
              Expanded(
                child: Text(
                  criterion,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                _ratings[criterion]!.toStringAsFixed(1),
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
              'Weekly Overall Rating',
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
                    'This Week\'s Performance:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _overallRating,
                    style: TextStyle(
                      fontSize: 14,
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
              label: 'Goals for Next Week',
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyCommentsSection() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Performance Comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Provide feedback on this week\'s performance, achievements, and areas for improvement',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _commentsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter comments about this week\'s performance, key achievements, challenges faced, and suggestions for improvement...',
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
            child: Text('Submit Weekly Evaluation', style: TextStyle(fontSize: 16, color: Colors.white)),
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
  Future<void> _submitEvaluation() async {
    if (_formKey.currentState!.validate()) {
      // Get current date for ratingDate
      final now = DateTime.now();
      final ratingDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      // Parse week period to get the start date (assuming first date is the start)
      final weekPeriod = _weekController.text.split(' - ').first;
      final weekParts = weekPeriod.split('/');
      final weekStartDate = '${weekParts[2]}-${weekParts[1].padLeft(2, '0')}-${weekParts[0].padLeft(2, '0')}';

      // Create the evaluation data map
      Map<String, dynamic> evaluationData = {
        "employeeId": _empId.text.trim(),
        "ratingDate": weekStartDate, // Using the start of the week period
        "qualityOfWork": _ratings['Quality of Work'],
        "productivity": _ratings['Productivity'],
        "technicalSkills": _ratings['Technical Skills'],
        "communication": _ratings['Communication'],
        "teamwork": _ratings['Teamwork'],
        "problemSolving": _ratings['Problem Solving'],
        "initiative": _ratings['Initiative'],
        "attendance": _ratings['Attendance'],
        "adaptability": _ratings['Adaptability'],
        "leadership": _ratings['Leadership'],
        "comments": _commentsController.text.trim(),
        "goals": _goalsController.text.trim(),
        "reviewedBy": DashboardHelpers.currentUser!.iDnum, // You might want to get this from user session
        "overallRating": _overallRating,
        "averageScore": _calculateAverageScore(),
        "weekPeriod": _weekController.text.trim(),
      };

      // Print the data for verification (you can replace this with API call)
      debugPrint('Evaluation Data: ${evaluationData.toString()}');

      // Here you would typically send this data to your API
       ApiService apiService=ApiService();
       var response=await apiService.postData('api/Support/SaveRatings', evaluationData);
      //evaluationData
      if(response!=null){
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Performance evaluation submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Optional: Clear form after submission
      // _clearForm();
    } else {
      // Show error message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Add this helper method to calculate average score
  double _calculateAverageScore() {
    return _ratings.values.reduce((a, b) => a + b) / _ratings.length;
  }

// Optional: Method to clear form after submission
  void _clearForm() {
    _formKey.currentState?.reset();
    _empId.clear();
    _commentsController.clear();
    _goalsController.clear();
    setState(() {
      selectedEmp = null;
      // Reset all ratings to 3.0
      for (var key in _ratings.keys) {
        _ratings[key] = 3.0;
      }
      _calculateOverallRating();
    });
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name.substring(0, 1).toUpperCase();
    }
    return 'N/A';
  }
}
