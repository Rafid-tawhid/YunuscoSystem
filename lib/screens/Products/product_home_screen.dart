import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/screens/Products/production_dashboard.dart';
import 'package:yunusco_group/screens/Products/widgets/production_screen.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../utils/colors.dart';
import 'widgets/buyers_screen.dart';

class ProductHomeScreen extends StatelessWidget {
  ProductHomeScreen({super.key});

  final List<String> _list=['Production','Production\nMonthly/Yearly','Buyers',];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Production Menu',style: customTextStyle(18, Colors.white, FontWeight.w600),),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: _list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                HapticFeedback.lightImpact();

                if (index == 0) {

                  var pp=context.read<ProductProvider>();
                  await pp.getAllProductionDashboard();
                  if(pp.productionDashboardModel!=null){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ProductionDashboard()),
                    );
                  }
                }
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductionSummaryScreen()),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  BuyersScreen()),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorPrimaryMain,
                      Color(0XFF260378),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorative elements
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Main content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            index == 0 ? Icons.assessment : Icons.people,
                            size: 44,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _list[index],
                            style:customTextStyle(18, Colors.white, FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}