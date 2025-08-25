import 'package:flutter/material.dart';
import 'package:yunusco_group/screens/Accounts/pf_info_screen.dart';
import 'package:yunusco_group/screens/Profile/change_password_screen.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';
import '../../common_widgets/dashboard_item_card.dart';

class AccountMenuScreen extends StatelessWidget {
  const AccountMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DashboardMenuItem> items = [
      DashboardMenuItem(
        name: 'Provident Fund',
        icon: Icons.wallet,
        cardColor: Colors.orange.shade100,
        iconColor: Colors.orangeAccent.shade700,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PfInfoScreen()));
        },
      ),
      DashboardMenuItem(
        name: 'Change Password',
        icon: Icons.lock,
        cardColor: Colors.purple.shade100,
        iconColor: Colors.purple.shade700,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
        },
      ),
    ];


    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          'Account Menu',
          style: customTextStyle(18, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return ReusableDashboardCard(menu: items[index]);
          },
        ),
      ),
    );
  }
}
