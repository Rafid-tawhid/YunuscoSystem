import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/screens/Products/widgets/production_screen.dart';

import 'widgets/buyers_screen.dart';

class ProductHomeScreen extends StatelessWidget {
  ProductHomeScreen({super.key});

  final List<String> _list=['Production','Buyers'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Menu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: _list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                if(index==1){
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>BuyersScreen()));
                }
                if(index==0){
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>ProductionSummaryScreen()));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _list[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}