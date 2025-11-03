import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/line_setup_model.dart';
import '../../providers/riverpods/planning_provider.dart';

class PlanningScreen extends ConsumerWidget {
  const PlanningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final planningAsync = ref.watch(planningProvider(selectedDate));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, ref, selectedDate),
      body: planningAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error, () => _retry(ref, selectedDate)),
        data: (list) => _buildContent(list, searchQuery),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref, DateTime selectedDate) {
    return AppBar(
      backgroundColor: myColors.primaryColor,
      foregroundColor: Colors.white,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Line Plan : "),
          Text(
            DateFormat('MMM-dd-yyyy').format(selectedDate),
            style: const TextStyle(fontSize: 16,),
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: (){
          _selectDate(context, ref);
        }, icon: Icon(Icons.calendar_month))
      ],
      bottom: _buildSearchBar(ref),
    );
  }

  PreferredSize _buildSearchBar(WidgetRef ref) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search by Name or Code",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
        ),
      ),
    );
  }

  Widget _buildContent(List<LineSetupModel> list, String searchQuery) {
    final filteredList = _filterList(list, searchQuery);

    if (filteredList.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) => _buildLineCard(filteredList[index]),
    );
  }

  List<LineSetupModel> _filterList(List<LineSetupModel> list, String searchQuery) {
    if (searchQuery.isEmpty) return list;

    final query = searchQuery.toLowerCase();
    return list.where((item) {
      final nameMatch = (item.name1 ?? "").toLowerCase().contains(query);
      final codeMatch = item.code?.toString().toLowerCase().contains(query) ?? false;
      return nameMatch || codeMatch;
    }).toList();
  }



  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ref.read(selectedDateProvider),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
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
                _buildInfoItem('Man Power', '${line.allocatedManPower ?? 'N/A'}'),
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
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading planning data...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: myColors.primaryColor),
              child: const Text('Retry',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  void _retry(WidgetRef ref, DateTime selectedDate) {
    ref.invalidate(planningProvider(selectedDate));
  }
}




//
// class PlanningScreen extends StatefulWidget {
//   const PlanningScreen({super.key});
//
//   @override
//   _PlanningScreenState createState() => _PlanningScreenState();
// }
//
// class _PlanningScreenState extends State<PlanningScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;
//   String? _selectedDate;
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     final provider = Provider.of<PlanningProvider>(context, listen: false);
//     _selectedDate = DashboardHelpers.convertDateTime2(DateTime.now());
//     provider.getAllPlanningList(_selectedDate!);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _isSearching ? _buildSearchAppBar() : _buildNormalAppBar(),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(_selectedDate ?? ''),
//               IconButton(
//                 icon: Icon(Icons.calendar_today, size: 20),
//                 onPressed: () async {
//                   final DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (picked != null) {
//                     // Handle the selected date
//                     String formattedDate =
//                         DateFormat('yyyy-MM-dd').format(picked);
//                     print("Selected date: $formattedDate");
//                     setState(() {
//                       _selectedDate = formattedDate;
//                     });
//                     provider.getAllPlanningList(_selectedDate!);
//                   }
//                 },
//                 tooltip: 'Select date',
//               ),
//             ],
//           ),
//           Expanded(child: _buildBody(lines)),
//         ],
//       ),
//     );
//   }
//
//   AppBar _buildNormalAppBar() {
//     return AppBar(
//       backgroundColor: myColors.primaryColor,
//       leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           )),
//       title: Text(
//         'Line Planning',
//         style: TextStyle(color: Colors.white),
//       ),
//       centerTitle: true,
//       actions: [
//         IconButton(
//           icon: Icon(
//             Icons.search,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             setState(() {
//               _isSearching = true;
//             });
//           },
//         ),
//       ],
//     );
//   }
//
//   AppBar _buildSearchAppBar() {
//     return AppBar(
//       backgroundColor: myColors.primaryColor,
//       leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           )),
//       title: TextField(
//         controller: _searchController,
//         autofocus: true,
//         decoration: InputDecoration(
//           hintText: 'Search lines...',
//           border: InputBorder.none,
//           hintStyle: TextStyle(color: Colors.white),
//         ),
//         style: TextStyle(color: Colors.white),
//         onChanged: (value) {
//           setState(() {});
//         },
//       ),
//       actions: [
//         IconButton(
//           icon: Icon(
//             Icons.clear,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             setState(() {
//               _isSearching = false;
//               _searchController.clear();
//             });
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBody(List<LineSetupModel> lines) {
//     final displayList = _isSearching
//         ? lines.where((line) {
//             final query = _searchController.text.toLowerCase();
//             return line.name1?.toLowerCase().contains(query) == true ||
//                 line.name2?.toLowerCase().contains(query) == true ||
//                 line.name3?.toLowerCase().contains(query) == true ||
//                 line.code?.toString().contains(query) == true;
//           }).toList()
//         : lines;
//
//     return ListView.builder(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       itemCount: displayList.length,
//       itemBuilder: (context, index) {
//         final line = displayList[index];
//         return _buildLineCard(line);
//       },
//     );
//   }
//
//   Widget _buildLineCard(LineSetupModel line) {
//     return Card(
//       color: Colors.white,
//       margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   line.name1 ?? 'Unnamed Line',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue[800],
//                   ),
//                 ),
//                 Chip(
//                   label: Text('Code: ${line.code ?? 'N/A'}'),
//                   backgroundColor: Colors.blue[50],
//                 ),
//               ],
//             ),
//             Divider(height: 20),
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               childAspectRatio: 4.2,
//               children: [
//                 _buildInfoItem('Target IE', '${line.targetValueIE ?? 'N/A'}'),
//                 _buildInfoItem('Target', '${line.targetValue ?? 'N/A'}'),
//                 _buildInfoItem('WIP', '${line.wip ?? 'N/A'}'),
//                 _buildInfoItem('SMV', '${line.smv ?? 'N/A'}'),
//                 _buildInfoItem(
//                     'Man Power', '${line.allocatedManPower ?? 'N/A'}'),
//                 _buildInfoItem('Hours', '${line.workingHour ?? 'N/A'}'),
//               ],
//             ),
//             Row(
//               children: [
//                 _buildStatusChip('Active', line.isActive ?? false),
//                 SizedBox(width: 8),
//                 _buildStatusChip('Plan Running', line.isPlanRunning ?? false),
//                 Spacer(),
//                 Text(
//                   line.allocationDate ?? 'No date',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoItem(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[600],
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusChip(String label, bool isActive) {
//     return Chip(
//       label: Text(label),
//       backgroundColor: isActive ? Colors.green[50] : Colors.grey[200],
//       labelStyle: TextStyle(
//         color: isActive ? Colors.green[800] : Colors.grey[600],
//       ),
//       shape: StadiumBorder(
//         side: BorderSide(
//           color: isActive ? Colors.green : Colors.grey,
//           width: 1,
//         ),
//       ),
//     );
//   }
// }
