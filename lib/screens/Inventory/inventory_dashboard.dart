import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';
import '../Products/garments_requisation_screen.dart';
import 'inventory_screen.dart';


class InventoryHomeScreen extends StatelessWidget {
  InventoryHomeScreen({super.key});

  final List<String> _list=['Inventory\nSummary','Garments\nRequisition'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Inventory Menu',style: customTextStyle(18, Colors.white, FontWeight.w600),),
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

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  InventoryStockScreen()),
                    );
                }
                if (index == 1) {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  GarmentsRequisitionScreen()),
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
                            getIcon(index),
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

  IconData? getIcon(int index) {
    if(index==0){
      return Icons.assessment;
    }
    if(index==1)
    {
      return Icons.assured_workload;
    }
    if(index==2)
    {
      return Icons.calendar_month;
    }
    if(index==3)
    {
      return Icons.people_alt_outlined;
    }
    if(index==4)
    {
      return Icons.style_sharp;
    }
    if(index==5)
    {
      return Icons.security_update_good;
    }
  }

  convertDate(DateTime date) {
    // Get the individual components
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0'); // Ensures two digits
    String day = date.day.toString().padLeft(2, '0'); // Ensures two digits

    // Combine them in YYYY-MM-DD format
    return '$year-$month-$day';

  }
}