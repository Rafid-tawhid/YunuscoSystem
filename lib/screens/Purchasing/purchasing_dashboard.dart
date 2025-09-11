import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yunusco_group/screens/Purchasing/purchase_dashboard.dart';
import 'package:yunusco_group/screens/Purchasing/purchase_requisation_list.dart';

import '../../common_widgets/dashboard_item_card.dart';
import '../../utils/colors.dart';
import '../Management/management_screen.dart';
import 'create_supplier_screen.dart';

class PurchasingDashboard extends StatelessWidget {
  const PurchasingDashboard({super.key});


  @override
  Widget build(BuildContext context) {
    late List<DashboardMenuItem> menuItems;
    menuItems = [
      DashboardMenuItem(
        name: "Purchase\nSummary",
        icon: Icons.account_tree,
        cardColor: Colors.blue.shade100,
        iconColor: Colors.blue,
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>PurchaseDashboardScreen()));
        },
      ),
      DashboardMenuItem(
        name: "Purchase\nRequisitions",
        icon: Icons.account_tree,
        cardColor: Colors.blue.shade100,
        iconColor: Colors.blue,
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>PurchaseRequisitionListScreen()));
        },
      ),
      DashboardMenuItem(
        name: "Create\n Supplier",
        icon: Icons.create_new_folder_sharp,
        cardColor: Colors.green.shade100,
        iconColor: Colors.green,
        onTap: (){
          //
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>SupplierFormScreen()));
        },
      ),

    ];

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          'Purchase',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.2,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            return ReusableDashboardCard(menu: menuItems[index]);
          },
        ),
      ),
    );
  }
}
