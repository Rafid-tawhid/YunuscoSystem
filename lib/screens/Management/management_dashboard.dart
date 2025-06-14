import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'management_screen.dart';

class ManagementDashboardScreen extends StatelessWidget {
  final List<DashboardItem> items = [
    DashboardItem("Production\nSummary", Icons.business, Colors.blue),
    DashboardItem("Departments", Icons.business, Colors.blue),
    DashboardItem("Sections", Icons.view_list, Colors.green),
    DashboardItem("Lines", Icons.line_style, Colors.orange),
    DashboardItem("Units", Icons.location_city, Colors.purple),
    DashboardItem("Designations", Icons.work, Colors.red),
    DashboardItem("Divisions", Icons.category, Colors.teal),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Management'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.2,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return DashboardCard(item: items[index]);
          },
        ),
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final Color color;

  DashboardItem(this.title, this.icon, this.color);
}

class DashboardCard extends StatelessWidget {
  final DashboardItem item;

  const DashboardCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          // Add navigation or action here
          print('${item.title} tapped');
          navigateToScreent(context,item);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                item.color.withOpacity(0.7),
                item.color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 48,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                item.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToScreent(BuildContext context, DashboardItem item) {
    if(item.title=='Production\nSummary'){
      Navigator.push(context, CupertinoPageRoute(builder: (context)=>ManagementProductionScreen()));
    }
  }
}