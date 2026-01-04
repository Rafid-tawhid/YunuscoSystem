import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:intl/intl.dart';
import '../../models/dhu_model.dart';
import '../../providers/riverpods/management_provider.dart';


class DHUScreen extends ConsumerWidget {
  const DHUScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Initialize with today's date
    final selectedDate = ref.watch(selectedDateProvider);
    final asyncData = ref.watch(mmrValueProvider(selectedDate));
    final dhuDataAsync = ref.watch(dhuDataProvider(selectedDate));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DHU Dashboard'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Date Picker Button
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 20),
            onPressed: () => _selectDate(context, ref),
            tooltip: 'Select Date',
          ),
          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh, size: 24),
            onPressed: () {
              ref.invalidate(dhuDataProvider);
              ref.invalidate(mmrValueProvider);
            },
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Display Card
          _buildDateCard(selectedDate, ref, context),

          // DHU Data Section
          Expanded(
            child: dhuDataAsync.when(
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading DHU Data...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                      const SizedBox(height: 24),
                      Text(
                        'Unable to load data',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.invalidate(dhuDataProvider);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              data: (dhuResponse) {
                final data = dhuResponse.data;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // MMR Value Card
                      asyncData.when(
                        data: (data) => _buildMMRCard(data['returnvalue'].toString()),
                        loading: () => _buildMMRCard('Loading...', isLoading: true),
                        error: (error, _) => _buildMMRCard('Error', isError: true),
                      ),
                      const SizedBox(height: 8),
                      // Total DHU Card
                      _buildTotalDHUCard(data.totalDHU),
                      const SizedBox(height: 20),

                      // Section-wise DHU
                      _buildSectionDHUCard(data.sectionWiseDHU),
                      const SizedBox(height: 20),

                      // Line-wise DHU
                      _buildLineDHUCard(data.lineWiseDHU),
                      const SizedBox(height: 120),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Date Selection Function
  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: myColors.primaryColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: myColors.primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      ref.read(selectedDateProvider.notifier).state = formattedDate;

      // Refresh data for the new date
      ref.invalidate(dhuDataProvider);
      ref.invalidate(mmrValueProvider);
    }
  }

  // Date Display Card Widget
  Widget _buildDateCard(String selectedDate, WidgetRef ref, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            myColors.primaryColor.withOpacity(0.1),
            myColors.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: myColors.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Date',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMMM dd, yyyy').format(DateTime.parse(selectedDate)),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: myColors.primaryColor,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => _selectDate(context, ref),
            icon: const Icon(Icons.calendar_month, size: 18),
            label: const Text('Change Date'),
            style: ElevatedButton.styleFrom(
              backgroundColor: myColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Your existing widget methods remain the same...
  Widget _buildMMRCard(String value, {bool isLoading = false, bool isError = false}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple[50]!,
              Colors.purple[100]!,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assessment_outlined,
                  color: Colors.purple[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Man vs Machine',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple[700],
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isLoading)
              const CircularProgressIndicator()
            else if (isError)
              Icon(
                Icons.error_outline,
                color: Colors.red[400],
                size: 32,
              )
            else
              Text(
                '${double.parse(value).toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalDHUCard(TotalDHU totalDHU) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[50]!,
              Colors.blue[100]!,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dashboard_outlined,
                  color: Colors.blue[700],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'OVERALL DHU',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${totalDHU.totalDHU}%',
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: totalDHU.totalDHU / 15,
              backgroundColor: Colors.blue[100],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getDHUColor(totalDHU.totalDHU),
              ),
              borderRadius: BorderRadius.circular(10),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              _getDHUStatus(totalDHU.totalDHU),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _getDHUColor(totalDHU.totalDHU),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDHUCard(List<SectionDHU> sections) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.view_quilt_outlined,
                  color: Colors.green[700],
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'SECTION-WISE DHU',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: ListView.separated(
                itemCount: sections.length,
                separatorBuilder: (context, index) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return _buildSectionItem(section);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionItem(SectionDHU section) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getDHUColor(section.sectionDHU),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Section ${section.sectionName}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '${section.sectionDHU}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _getDHUColor(section.sectionDHU),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: section.sectionDHU / 15,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getDHUColor(section.sectionDHU),
                ),
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
              const SizedBox(height: 4),
              Text(
                _getDHUStatus(section.sectionDHU),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineDHUCard(List<LineDHU> lines) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.view_agenda_outlined,
                  color: Colors.orange[700],
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'LINE-WISE DHU',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${lines.length} Lines',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 320,
              child: ListView.separated(
                itemCount: lines.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final line = lines[index];
                  return _buildLineItem(line);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItem(LineDHU line) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _getDHUColor(line.lineDHU).withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getDHUColor(line.lineDHU).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: _getDHUColor(line.lineDHU),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                line.lineName.split('-').last,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getDHUColor(line.lineDHU),
                ),
              ),
            ),
          ),
          title: Text(
            line.lineName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: line.lineDHU / 30,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getDHUColor(line.lineDHU),
                ),
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
              const SizedBox(height: 4),
              Text(
                _getDHUStatus(line.lineDHU),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getDHUColor(line.lineDHU).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getDHUColor(line.lineDHU).withOpacity(0.3),
              ),
            ),
            child: Text(
              '${line.lineDHU}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getDHUColor(line.lineDHU),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getDHUColor(double dhuValue) {
    if (dhuValue <= 5) return Colors.green;
    if (dhuValue <= 8) return Colors.orange;
    return Colors.red;
  }

  String _getDHUStatus(double dhuValue) {
    if (dhuValue <= 5) return 'Excellent';
    if (dhuValue <= 8) return 'Good';
    return 'Needs Attention';
  }
}