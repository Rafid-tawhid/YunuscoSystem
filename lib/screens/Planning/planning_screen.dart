import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../providers/planning_provider.dart';
import '../../utils/constants.dart';

class PlanningScreen extends StatefulWidget {


  const PlanningScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  @override
  void initState() {
    var pp=context.read<PlanningProvider>();
    pp.getAllPlanningList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Planning Screen',
          style: customTextStyle(18, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: Provider.of<PlanningProvider>(context).allPlanningList.isEmpty
          ? _buildEmptyState()
          : Consumer<PlanningProvider>(
        builder: (context,pro,_)=>Column(
          children: [
            _buildSummaryHeader(pro),
            Expanded(
              child: _buildList(pro),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildSummaryHeader(PlanningProvider pro) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: myColors.primaryColor.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Items: ${pro.allPlanningList.length}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: myColors.black,
            ),
          ),
          Text(
            'Tap item for details',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(PlanningProvider pro) {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: pro.allPlanningList.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final item = pro.allPlanningList[index];
        return _buildListItem(item, index);
      },
    );
  }

  Widget _buildListItem(Map<String, dynamic> item, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _showItemDetails(item),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: myColors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? 'No Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Code: ${item['code'] ?? 'N/A'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt,
            size: 64,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No Items Found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add new items using the + button',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  void _showSearch(BuildContext context) {
    var pp=context.read<PlanningProvider>();
    showSearch(
      context: context,
      delegate: _CodeNameSearchDelegate(pp.allPlanningList.map((item) {
        return {
          'name': item['name']?.toString() ?? '',
          'code': item['code']?.toString() ?? '',
        };
      }).toList()),
    );
  }

  void _showItemDetails(Map<String, dynamic> item) {
    // Implement item details view
    print('Selected item: $item');
    DashboardHelpers.showAlert(msg: 'No Data Found');
  }
}

class _CodeNameSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> items;

  _CodeNameSearchDelegate(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = query.isEmpty
        ? items
        : items.where((item) =>
    (item['name']?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        (item['code']?.toLowerCase().contains(query.toLowerCase()) ?? false))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text('No matching items found'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: Text(item['code']?.substring(0, 1) ?? '?'),
          ),
          title: Text(item['name'] ?? 'No Name'),
          subtitle: Text('Code: ${item['code'] ?? 'N/A'}'),
          onTap: () {
            close(context, item);
          },
        );
      },
    );
  }
}