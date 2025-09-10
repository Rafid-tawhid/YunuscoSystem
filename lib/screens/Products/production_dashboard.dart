import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/screens/Products/widgets/date_picker_Card.dart';
import 'package:yunusco_group/screens/Products/widgets/section_wise_dhu.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../models/production_dashboard_model.dart';
import '../../providers/product_provider.dart';

import 'package:fl_chart/fl_chart.dart';

class ProductionDashboard extends StatelessWidget {
  const ProductionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final data = provider.productionDashboardModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Production Summary',),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: myColors.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            DatePickerCard(
              initialDate: DateTime.now(),
              onDateSelected: (date) async {
                var pp = context.read<ProductProvider>();
                await pp.getAllProductionDashboard();
                pp.getAllDhuInfo(date);
              },
              label: 'To Date',
            ),
            // Summary Cards
            _buildSummaryCards(data?.productionData?.first),
            const SizedBox(height: 24),


           if(provider.totalDhu.isNotEmpty) Align(
              alignment: Alignment.center,
              child: Text('Total DHU ${provider.totalDhu}',style: customTextStyle(20, Colors.blue, FontWeight.bold),),
            ),
            const SizedBox(height: 24),
            if(provider.sectionWiseDhu.isNotEmpty)SectionDataScreen(sections: provider.sectionWiseDhu,),

           if(provider.lineWiseDHU.isNotEmpty) LineWiseDHU(lines: provider.lineWiseDHU,),

            // Production Progress Charts
            _buildProductionCharts(data),
            const SizedBox(height: 24),

            // Detailed Tables
            _buildProductionTables(data),
            const SizedBox(height: 24),
            // Unit Wise Sewing Charts
            _buildUnitWiseCharts(data),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(ProductionData? data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildSummaryCard('Cutting', data?.cuttingQty ?? 0, Colors.blue),
        _buildSummaryCard('Sewing', data?.sewingQty ?? 0, Colors.green),
        _buildSummaryCard('Finish', data?.finishQty ?? 0, Colors.orange),
        _buildSummaryCard('Molding', data?.moldingQty ?? 0, Colors.purple),
      ],
    );
  }

  Widget _buildSummaryCard(String title, num value, Color color) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitWiseCharts(ProductionDashboardModel? data) {
    final sewingData = data?.unitWiseSewing ?? [];
    final sewingYData = data?.unitWiseSewingY ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Unit Wise Production',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(sewingData.length, (index) {
                return ConstrainedBox(
                  constraints:
                      BoxConstraints(minWidth: 60), // Minimum width per bar
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 20,
                        height:
                            (sewingData[index].quantity?.toDouble() ?? 0) * 2,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 20,
                        height:
                            (sewingYData[index].quantity?.toDouble() ?? 0) * 2,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: 60,
                          child: Text(
                            sewingData[index].unitName ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10),
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildChartLegend('Sewing', Colors.blue),
            const SizedBox(width: 16),
            _buildChartLegend('Sewing Y', Colors.green),
          ],
        ),
      ],
    );
  }

  double _calculateMaxY(
      List<UnitWiseSewing> sewingData, List<UnitWiseSewingY> sewingYData) {
    double maxSewing = sewingData.fold(
        0,
        (max, item) => item.quantity != null && item.quantity! > max
            ? item.quantity!.toDouble()
            : max);
    double maxSewingY = sewingYData.fold(
        0,
        (max, item) => item.quantity != null && item.quantity! > max
            ? item.quantity!.toDouble()
            : max);
    return maxSewing > maxSewingY ? maxSewing : maxSewingY;
  }

  Widget _buildChartLegend(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }

  Widget _buildProductionCharts(ProductionDashboardModel? data) {
    final chartData = data?.morrisLine ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Production Progress',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  // tooltipBgColor: Colors.grey[800],
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((spot) {
                      final name = spot.x.toInt() < chartData.length
                          ? chartData[spot.x.toInt()].name ?? ''
                          : '';
                      return LineTooltipItem(
                        '$name\n${spot.y.toInt()}',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < chartData.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            chartData[index].name!.substring(5),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 40,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              minX: 0,
              maxX: (chartData.length - 1).toDouble(),
              minY: 0,
              maxY: _calculateMaxLineY(chartData) * 1.2,
              lineBarsData: [
                LineChartBarData(
                  spots: chartData.asMap().entries.map((entry) {
                    return FlSpot(
                      entry.key.toDouble(),
                      entry.value.acheiveQty?.toDouble() ?? 0,
                    );
                  }).toList(),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
                LineChartBarData(
                  spots: chartData.asMap().entries.map((entry) {
                    return FlSpot(
                      entry.key.toDouble(),
                      entry.value.targetQty?.toDouble() ?? 0,
                    );
                  }).toList(),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildChartLegend('Achieved', Colors.green),
            const SizedBox(width: 16),
            _buildChartLegend('Target', Colors.blue),
          ],
        ),
      ],
    );
  }

  double _calculateMaxLineY(List<MorrisLine> data) {
    double maxAchieved = data.fold(
        0,
        (max, item) => item.acheiveQty != null && item.acheiveQty! > max
            ? item.acheiveQty!.toDouble()
            : max);
    double maxTarget = data.fold(
        0,
        (max, item) => item.targetQty != null && item.targetQty! > max
            ? item.targetQty!.toDouble()
            : max);
    return maxAchieved > maxTarget ? maxAchieved : maxTarget;
  }

  Widget _buildProductionTables(ProductionDashboardModel? data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed Production Data',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (data?.sewingProduction != null)
          _buildDataTable(
            'Sewing Production',
            ['Section', 'Lines', 'Target', 'Achieved', '%'],
            data!.sewingProduction!
                .map((e) => [
                      e.sections ?? '',
                      e.lineRunning?.toString() ?? '',
                      e.totalTarget?.toString() ?? '',
                      e.achieveQty?.toString() ?? '',
                      '${e.achievePercent?.toStringAsFixed(1)}%',
                    ])
                .toList(),
          ),
        const SizedBox(height: 16),
        if (data?.finishProduction != null)
          _buildDataTable(
            'Finish Production',
            ['Section', 'Tables', 'Target', 'Achieved', '%'],
            data!.finishProduction!
                .map((e) => [
                      e.sections ?? '',
                      e.tableRunning?.toString() ?? '',
                      e.totalTarget?.toString() ?? '',
                      e.achieveQty?.toString() ?? '',
                      '${e.achievePercent?.toStringAsFixed(1)}%',
                    ])
                .toList(),
          ),
      ],
    );
  }
  //

  Widget _buildDataTable(
      String title, List<String> headers, List<List<String>> rows) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: headers
                    .map((header) => DataColumn(
                          label: Text(
                            header,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
                rows: rows
                    .map((row) => DataRow(
                          cells:
                              row.map((cell) => DataCell(Text(cell))).toList(),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
