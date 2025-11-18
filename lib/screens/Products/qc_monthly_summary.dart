import 'package:flutter/material.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/qc_pass_summary_model.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:flutter/material.dart';

class QcPassSummaryScreen extends StatefulWidget {
  final List<QcPassSummaryModel> monthlyData;

  const QcPassSummaryScreen({Key? key, required this.monthlyData}) : super(key: key);

  @override
  State<QcPassSummaryScreen> createState() => _QcPassSummaryScreenState();
}

class _QcPassSummaryScreenState extends State<QcPassSummaryScreen> {
  late List<QcPassSummaryModel> _filteredData;
  String? _selectedMonth;
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _filteredData = widget.monthlyData;
    // Set current month as default
    _selectedMonth = _months[DateTime.now().month - 1];
    _filterByMonth(_selectedMonth!);
  }

  void _filterByMonth(String month) {
    final monthIndex = _months.indexOf(month) + 1;
    setState(() {
      _filteredData = widget.monthlyData.where((item) {
        if (item.day == null) return false;
        final date = DateTime.parse(item.day!);
        return date.month == monthIndex;
      }).toList();
    });
  }

  (DateTime, DateTime) _getFirstLastDayOfMonth(String month) {
    final monthIndex = _months.indexOf(month) + 1;
    final now = DateTime.now();
    final firstDay = DateTime(now.year, monthIndex, 1);
    final lastDay = DateTime(now.year, monthIndex + 1, 0);
    return (firstDay, lastDay);
  }

  @override
  Widget build(BuildContext context) {
    final (firstDay, lastDay) = _getFirstLastDayOfMonth(_selectedMonth!);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('QC Pass Summary - Monthly Report'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Month Selector and Date Range
            _buildMonthSelector(firstDay, lastDay),
        
            _buildPassTrendChart(),
            // Summary Cards
            _buildSummaryCards(),
            SizedBox(height: 16,),
            // Data Table
            _buildDataTable(),
        
        
        
        
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector(DateTime firstDay, DateTime lastDay) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Month',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedMonth,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMonth = newValue!;
                          _filterByMonth(newValue);
                        });
                      },
                      items: _months.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),


              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date Range',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${DashboardHelpers.convertDateTime(firstDay.toString(), pattern: 'dd MMM')} - ${DashboardHelpers.convertDateTime(lastDay.toString(), pattern: 'dd MMM yyyy')}',
                    style:  TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    if (_filteredData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(4),
        child: Text(
          'No data available for selected month',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      );
    }

    final totalPass = _filteredData.fold<num>(0, (sum, item) => sum + (item.totalPass ?? 0));
    final totalDefect = _filteredData.fold<num>(0, (sum, item) => sum + (item.totalDefect ?? 0));
    final totalReject = _filteredData.fold<num>(0, (sum, item) => sum + (item.totalReject ?? 0));
    final totalDefectiveGarments = _filteredData.fold<num>(0, (sum, item) => sum + (item.totalDefectiveGarments ?? 0));
    final totalAlterCheck = _filteredData.fold<num>(0, (sum, item) => sum + (item.totalAlterCheck ?? 0));

    return Container(
      padding: const EdgeInsets.all(4),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          _buildSummaryCard('Pass', totalPass, Icons.check_circle, Colors.green),
          _buildSummaryCard('Defects', totalDefect, Icons.warning, Colors.orange),
          _buildSummaryCard('Rejects', totalReject, Icons.cancel, Colors.red),
          _buildSummaryCard('D.G', totalDefectiveGarments, Icons.assignment_late, Colors.amber),
          _buildSummaryCard('Alter', totalAlterCheck, Icons.build, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, num value, IconData icon, Color color) {
    return Container(
      width: 80,
      height: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 4),
          Text(
            value.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    if (_filteredData.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.data_array, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No data available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: myColors.primaryColor.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Pass',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Defects',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'D.G',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Reject',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Alter',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Table Data
            ListView.builder(
              itemCount: _filteredData.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = _filteredData[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade100,
                        width: 1,
                      ),
                    ),
                    color: index.isEven ? Colors.white : Colors.grey.shade50,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            DashboardHelpers.convertDateTime(item.day.toString(), pattern: 'dd-MM-yyyy'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${item.totalPass ?? 0}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${item.totalDefect ?? 0}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${item.totalDefectiveGarments ?? 0}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${item.totalReject ?? 0}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${item.totalAlterCheck ?? 0}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassTrendChart() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            '$_selectedMonth Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              // Chart background and border

              primaryXAxis: CategoryAxis(
                labelRotation: -45,
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 1, color: Colors.grey),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(color: Colors.grey, width: 0.5),
                axisLine: const AxisLine(width: 1, color: Colors.grey),
                majorTickLines: const MajorTickLines(size: 0),
                // labelFormatter: (axisLabelRenderArgs) {
                //   final value = double.tryParse(axisLabelRenderArgs.text) ?? 0;
                //   if (value >= 1000) {
                //     return '${(value / 1000).toStringAsFixed(0)}K';
                //   }
                //   return value.toStringAsFixed(0);
                // },
              ),

              series: <CartesianSeries>[
                LineSeries<QcPassSummaryModel, String>(
                  dataSource: widget.monthlyData,
                  xValueMapper: (QcPassSummaryModel data, _) => _formatDateForChart(data.day),
                  yValueMapper: (QcPassSummaryModel data, _) => data.totalPass?.toDouble(),
                  name: 'Pass',
                  color: Colors.green.shade600,
                  width: 3,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    color: Colors.green,
                    borderWidth: 2,
                    borderColor: Colors.white,
                    shape: DataMarkerType.circle,
                    height: 6,
                    width: 6,
                  ),
                ),
              ],

              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: Colors.green.shade100,
                borderColor: Colors.green,
                borderWidth: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateForChart(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}';
    } catch (e) {
      return dateString;
    }
  }
}