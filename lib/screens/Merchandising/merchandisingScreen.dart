import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/management_provider.dart';
import 'package:yunusco_group/providers/merchandising_provider.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/buyer_wise_order_quantity.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/buyer_wise_order_value.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/item_wise_sales_value.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/order_shipment_chart.dart';

import '../../models/buyer_wise_value_model.dart';

class MerchandisingScreen extends StatefulWidget {
  const MerchandisingScreen({super.key});

  @override
  State<MerchandisingScreen> createState() => _MerchandisingScreenState();
}

class _MerchandisingScreenState extends State<MerchandisingScreen> {
  @override
  void initState() {
    super.initState();
    var mp=context.read<ManagementProvider>();
    mp.getAllManagementInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Merchandising')),
      body: Consumer<MerchandisingProvider>(
        builder: (context, provider, _) {
          final model = provider.buyerWiseValueModel;
          if (model == null) {
            return const Center(child: Text('Nothing to show..'));
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
                              color: Colors.blue,
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    provider.buyerWiseValueModel!.summary![0].costingCount.toString(),
                                    style: TextStyle(color: Colors.white),
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
                              color: Colors.green,
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    provider.buyerWiseValueModel!.summary![0].orderQuantity.toString(),
                                    style: TextStyle(color: Colors.white),
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
                              color: Colors.green,
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    provider.buyerWiseValueModel!.summary![0].orderValue.toString(),
                                    style: TextStyle(color: Colors.white),
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
                              color: Colors.blue,
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    provider.buyerWiseValueModel!.summary![0].purchaseValue.toString(),
                                    style: TextStyle(color: Colors.white),
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


