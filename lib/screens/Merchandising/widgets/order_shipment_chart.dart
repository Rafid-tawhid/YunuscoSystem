import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/buyer_wise_value_model.dart';

class OrderVsShipmentChart extends StatefulWidget {
  final List<MorrisLine> morrisLine;

  const OrderVsShipmentChart({super.key, required this.morrisLine});

  @override
  State<OrderVsShipmentChart> createState() => _OrderVsShipmentChartState();
}

class _OrderVsShipmentChartState extends State<OrderVsShipmentChart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        SizedBox(
          height: 300,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: widget.morrisLine.length * 60, // width based on data
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LineChart(getMorrisLineChartData(widget.morrisLine)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData getMorrisLineChartData(List<MorrisLine> morris) {
    return LineChartData(
      minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: morris.asMap().entries.map((e) {
            return FlSpot(
              e.key.toDouble(),
              e.value.orderValue?.toDouble() ?? 0,
            );
          }).toList(),
          isCurved: true,
          color: Colors.blue,
          barWidth: 2,
          dotData: FlDotData(show: true),
        ),
        LineChartBarData(
          spots: morris.asMap().entries.map((e) {
            return FlSpot(
              e.key.toDouble(),
              e.value.shipmentValue?.toDouble() ?? 0,
            );
          }).toList(),
          isCurved: true,
          color: Colors.green,
          barWidth: 2,
          dotData: FlDotData(show: true),
        ),
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            interval: 1,
            getTitlesWidget: (value, _) {
              int index = value.toInt();
              if (index >= 0 && index < morris.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    morris[index].monthName ?? '',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 60),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: true),
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.x.toInt();
              final item = morris[index];
              return LineTooltipItem(
                '${item.monthName ?? ''}\nOrder: \$${item.orderValue?.toStringAsFixed(0) ?? '0'}\nShipment: \$${item.shipmentValue?.toStringAsFixed(0) ?? '0'}',
                const TextStyle(color: Colors.black),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
