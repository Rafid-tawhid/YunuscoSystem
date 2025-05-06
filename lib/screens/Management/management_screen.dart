import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/management_provider.dart';
import 'package:yunusco_group/screens/Management/widgets/finish_production_section.dart';
import 'package:yunusco_group/screens/Management/widgets/sewing_target_achieve.dart';
import 'package:yunusco_group/screens/Management/widgets/sewing_production_section.dart';
import 'package:yunusco_group/screens/Management/widgets/unit_wise_sewing.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../models/management_dashboard_model.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  @override
  void initState() {
    super.initState();
    var mp = context.read<ManagementProvider>();
    mp.getAllManagementInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Management',
          style: customTextStyle(18, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Consumer<ManagementProvider>(
          builder: (context, provider, _) => provider.managementDashboardData != null
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Production Data',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ProductionDataSection(productionData: provider.managementDashboardData!.productionData),

                    // UnitWiseSewing Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Unit Wise Sewing',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    UnitWiseSewingSection(unitWiseSewing: provider.managementDashboardData!.unitWiseSewing),

                    // Sewing Production Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sewing Production',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    SewingProductionSection(sewingProduction: provider.managementDashboardData!.sewingProduction),

                    // Morris Line Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Morris Line',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    MorrisLineSection(morrisLine: provider.managementDashboardData!.morrisLine),

                    // Finish Production Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Finish Production',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    FinishProductionSection(finishProduction: provider.managementDashboardData!.finishProduction),

                    // // Unit Wise Sewing Y Section
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     'Unit Wise Sewing Y',
                    //     style: Theme.of(context).textTheme.titleLarge,
                    //   ),
                    // ),
                    // UnitWiseSewingYSection(unitWiseSewingY: provider.managementDashboardData!.unitWiseSewingY),
                    //
                    // // Finish Fifteen Section
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     'Finish Fifteen',
                    //     style: Theme.of(context).textTheme.titleLarge,
                    //   ),
                    // ),
                    // FinishFifteenSection(finishFifteen: provider.managementDashboardData!.finishFifteen),
                  ],
                )
              : Center(
                  child: Text('Loading....'),
                ),
        ),
      ),
    );
  }
}

class ProductionDataSection extends StatelessWidget {
  final List<ProductionData>? productionData;

  ProductionDataSection({this.productionData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Summary This Month',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'This Month',
                        style: AppConstants.customTextStyle(14, Colors.white, FontWeight.w600),
                      ),
                      Text(
                        'Sewing :${productionData!.first.sewingQty.toString()}',
                        style: AppConstants.customTextStyle(14, Colors.white, FontWeight.w600),
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Previous Month',
                        style: AppConstants.customTextStyle(14, Colors.white, FontWeight.w600),
                      ),
                      Text(
                        'Sewing :${productionData!.first.cuttingQty.toString()}',
                        style: AppConstants.customTextStyle(14, Colors.white, FontWeight.w600),
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'This Month',
                        style: AppConstants.customTextStyle(14, Colors.white, FontWeight.w600),
                      ),
                      Text(
                        'Finish :${productionData!.first.finishQty.toString()}',
                        style: AppConstants.customTextStyle(14, Colors.white, FontWeight.w600),
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Previous Month',
                        style: AppConstants.customTextStyle(14, Colors.white, FontWeight.w600),
                      ),
                      Text(
                        'Finish :${productionData!.first.moldingQty.toString()}',
                        style: AppConstants.customTextStyle(14, Colors.white, FontWeight.w600),
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
    );
  }
}

class UnitWiseSewingYSection extends StatelessWidget {
  final List<UnitWiseSewingY>? unitWiseSewingY;

  UnitWiseSewingYSection({this.unitWiseSewingY});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: unitWiseSewingY?.map((data) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text('Unit: ${data.unitName}'),
                subtitle: Text('Quantity: ${data.quantity}'),
              ),
            );
          }).toList() ??
          [],
    );
  }
}

class FinishFifteenSection extends StatelessWidget {
  final List<FinishFifteen>? finishFifteen;

  FinishFifteenSection({this.finishFifteen});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: finishFifteen?.map((data) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text('Name: ${data.name}'),
                subtitle: Text(
                  'Target: ${data.targetQty}\nAchieve: ${data.acheiveQty}',
                ),
              ),
            );
          }).toList() ??
          [],
    );
  }
}
