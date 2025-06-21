import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/management_provider.dart';
import 'package:yunusco_group/providers/merchandising_provider.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/buyer_wise_order_quantity.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/buyer_wise_order_value.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/item_wise_sales_value.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/order_shipment_chart.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../models/buyer_wise_value_model.dart';
import 'buyer_order_Screen.dart';

class MerchandisingSummaryScreen extends StatefulWidget {
  const MerchandisingSummaryScreen({super.key});

  @override
  State<MerchandisingSummaryScreen> createState() => _MerchandisingSummaryScreenState();
}

class _MerchandisingSummaryScreenState extends State<MerchandisingSummaryScreen> {
  @override
  void initState() {
    super.initState();
    var mp=context.read<MerchandisingProvider>();
    mp.getAllMerchandisingInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Summary Chart'),

      actions: [
        IconButton(
          onPressed: () {
            showMenu(

              context: context,
              position: RelativeRect.fromLTRB(
                // Position the menu below the button
                MediaQuery.of(context).size.width - 160, // Right offset
                80.0, // Top offset (adjust based on your app bar height)
                MediaQuery.of(context).size.width, // Left offset
                0, // Bottom offset
              ),
              items: [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Text('Buyer Order'),
                    ],
                  ),
                ),


              ],
              elevation: 8.0,
            ).then((value) {
              if (value != null) {
                // Handle menu item selection
                debugPrint('This is value ren ${value}');
                switch (value) {
                  case 1:
                    Navigator.push(context, CupertinoPageRoute(builder: (context)=>BuyerOrderScreen()));
                    break;

                }
              }
            });
          },
          icon: Icon(Icons.menu, color: Colors.black,),
        )
      ],),
      body: Consumer<MerchandisingProvider>(
        builder: (context, provider, _) {
          final model = provider.buyerWiseValueModel;
          if (model == null) {
            return const Center(child: Text('Loading..'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Summary (Last 30 days)',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: myColors.orange,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child:  Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Costing',
                                    style: AppConstants.customTextStyle(14, Colors.white, FontWeight.normal),
                                  ),
                                  Text(
                                    provider.buyerWiseValueModel!.summary![0].costingCount.toString(),
                                    style: AppConstants.customTextStyle(14, Colors.white, FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: myColors.paste,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                            child:  Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Order Quantity',
                                    style: AppConstants.customTextStyle(14, Colors.white, FontWeight.normal),
                                  ),
                                  Text(
                                    provider.buyerWiseValueModel!.summary![0].orderQuantity.toString(),
                                    style: AppConstants.customTextStyle(14, Colors.white, FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: myColors.paste,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child:  Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Order Value',
                                    style: AppConstants.customTextStyle(14, Colors.white, FontWeight.normal),
                                  ),
                                  Text(
                                    provider.buyerWiseValueModel!.summary![0].orderValue.toString(),
                                    style: AppConstants.customTextStyle(14, Colors.white, FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: myColors.orange,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                            child:  Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Purchase Value',
                                    style: AppConstants.customTextStyle(14, Colors.white, FontWeight.normal),
                                  ),
                                  Text(
                                    provider.buyerWiseValueModel!.summary![0].purchaseValue.toString(),
                                    style: AppConstants.customTextStyle(14, Colors.white, FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                const Text("📊 Buyer wise order quantity (Last 30 days)", style: TextStyle(fontWeight: FontWeight.bold)),
                BuyerQtyPieChart(items: provider.buyerWiseValueModel?.buyerWiseQty ?? []),
                const SizedBox(height: 24),
                const Text("📊 Item wise sales value (Last 30 days)", style: TextStyle(fontWeight: FontWeight.bold)),
                ItemWiseSalesChart(items: provider.buyerWiseValueModel?.itemWiseWise ?? []),
                const SizedBox(height: 24),
                const Text("📈 Monthly Order vs Shipment (Line Chart)", style: TextStyle(fontWeight: FontWeight.bold)),
                OrderVsShipmentChart(morrisLine: provider.buyerWiseValueModel!.morrisLine??[]),
                const SizedBox(height: 24),
                const Text("🥧 Buyer wise order value",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 350, child: BarChartExample(items: provider.buyerWiseValueModel!.buyerWiseQty??[])),
              ],
            ),
          );
        },
      ),
    );
  }
  
}


