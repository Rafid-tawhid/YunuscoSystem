import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/line_setup_model.dart';
import 'package:yunusco_group/providers/planning_provider.dart';
import 'package:yunusco_group/utils/colors.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _selectedDate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final provider = Provider.of<PlanningProvider>(context, listen: false);
    _selectedDate = DashboardHelpers.convertDateTime2(DateTime.now());
    provider.getAllPlanningList(_selectedDate!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanningProvider>(context);
    final lines = provider.allPlanningList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isSearching ? _buildSearchAppBar() : _buildNormalAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_selectedDate ?? ''),
              IconButton(
                icon: Icon(Icons.calendar_today, size: 20),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    // Handle the selected date
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(picked);
                    print("Selected date: $formattedDate");
                    setState(() {
                      _selectedDate = formattedDate;
                    });
                    provider.getAllPlanningList(_selectedDate!);
                  }
                },
                tooltip: 'Select date',
              ),
            ],
          ),
          Expanded(child: _buildBody(lines)),
        ],
      ),
    );
  }

  AppBar _buildNormalAppBar() {
    return AppBar(
      backgroundColor: myColors.primaryColor,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
      title: Text(
        'Line Planning',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ],
    );
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      backgroundColor: myColors.primaryColor,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search lines...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          setState(() {});
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildBody(List<LineSetupModel> lines) {
    final displayList = _isSearching
        ? lines.where((line) {
            final query = _searchController.text.toLowerCase();
            return line.name1?.toLowerCase().contains(query) == true ||
                line.name2?.toLowerCase().contains(query) == true ||
                line.name3?.toLowerCase().contains(query) == true ||
                line.code?.toString().contains(query) == true;
          }).toList()
        : lines;

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final line = displayList[index];
        return _buildLineCard(line);
      },
    );
  }

  Widget _buildLineCard(LineSetupModel line) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  line.name1 ?? 'Unnamed Line',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                Chip(
                  label: Text('Code: ${line.code ?? 'N/A'}'),
                  backgroundColor: Colors.blue[50],
                ),
              ],
            ),
            Divider(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 4.2,
              children: [
                _buildInfoItem('Target IE', '${line.targetValueIE ?? 'N/A'}'),
                _buildInfoItem('Target', '${line.targetValue ?? 'N/A'}'),
                _buildInfoItem('WIP', '${line.wip ?? 'N/A'}'),
                _buildInfoItem('SMV', '${line.smv ?? 'N/A'}'),
                _buildInfoItem(
                    'Man Power', '${line.allocatedManPower ?? 'N/A'}'),
                _buildInfoItem('Hours', '${line.workingHour ?? 'N/A'}'),
              ],
            ),
            Row(
              children: [
                _buildStatusChip('Active', line.isActive ?? false),
                SizedBox(width: 8),
                _buildStatusChip('Plan Running', line.isPlanRunning ?? false),
                Spacer(),
                Text(
                  line.allocationDate ?? 'No date',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, bool isActive) {
    return Chip(
      label: Text(label),
      backgroundColor: isActive ? Colors.green[50] : Colors.grey[200],
      labelStyle: TextStyle(
        color: isActive ? Colors.green[800] : Colors.grey[600],
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: isActive ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
    );
  }
}
