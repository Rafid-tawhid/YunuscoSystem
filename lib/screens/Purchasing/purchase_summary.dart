import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/purchase_dashboard_analytics_model.dart';
import '../../providers/product_provider.dart';

class PurchaseDashboardScreen extends StatefulWidget {
  const PurchaseDashboardScreen({super.key});

  @override
  State<PurchaseDashboardScreen> createState() => _PurchaseDashboardScreenState();
}

class _PurchaseDashboardScreenState extends State<PurchaseDashboardScreen> {
  int _currentBarChartIndex = -1;
  int _currentPieChartIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .getAllPurchaseDashboardInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Purchase Dashboard'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.purchaseAnalyticsResponse == null) {
            return const Center(child: Text('No data available'));
          }

          final data = provider.purchaseAnalyticsResponse!;

          return RefreshIndicator(
            onRefresh: () => provider.getAllPurchaseDashboardInfo(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Yearly Summary Card
                  _buildYearlySummaryCard(data),
                  const SizedBox(height: 20),

                  // Monthly Purchases Bar Chart
                  _buildMonthlyBarChart(data),
                  const SizedBox(height: 20),

                  // Key Metrics Grid
                  _buildKeyMetricsGrid(data),
                  const SizedBox(height: 20),

                  // Top Products Pie Chart
                  _buildTopProductsPieChart(data),
                  const SizedBox(height: 20),

                  // Top Suppliers Chart
                  _buildTopSuppliersChart(data),
                  const SizedBox(height: 20),

                  // Detailed Lists
                  _buildDetailedLists(data),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearlySummaryCard(PurchaseAnalyticsResponse data) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: myColors.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'YEARLY PURCHASE SUMMARY',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                formatter.format(data.yearlyGrandTotal.grandTotalPurchase),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${data.currentYearMonthlyPurchases.first.purchaseYear} Total',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              _buildMonthlyTrendIndicator(data),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyTrendIndicator(PurchaseAnalyticsResponse data) {
    final currentMonth = data.currentYearMonthlyPurchases.last;
    final previousMonth = data.currentYearMonthlyPurchases.length > 1
        ? data.currentYearMonthlyPurchases[data.currentYearMonthlyPurchases.length - 2]
        : null;

    if (previousMonth == null) {
      return const Text(
        'No previous month data',
        style: TextStyle(color: Colors.white70),
      );
    }

    final trend = currentMonth.totalPurchase - previousMonth.totalPurchase;
    final isPositive = trend >= 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          color: isPositive ? Colors.green[300] : Colors.red[300],
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          '${isPositive ? '+' : ''}${formatter.format(trend)} from last month',
          style: TextStyle(
            color: isPositive ? Colors.green[300] : Colors.red[300],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyBarChart(PurchaseAnalyticsResponse data) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Purchase Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Total purchases by month',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          _currentBarChartIndex = -1;
                        });
                        return;
                      }
                      setState(() {
                        _currentBarChartIndex = response.spot!.touchedBarGroupIndex;
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < data.currentYearMonthlyPurchases.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                data.currentYearMonthlyPurchases[index].monthName.substring(0, 3),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: data.currentYearMonthlyPurchases
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final monthlyData = entry.value;
                    final isTouched = index == _currentBarChartIndex;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: monthlyData.totalPurchase,
                          gradient: LinearGradient(
                            colors: [
                              isTouched ? myColors.primaryColor : Colors.blue[800]!,
                              isTouched ? Colors.blue[600]! : Colors.blue[200]!,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetricsGrid(PurchaseAnalyticsResponse data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildMetricCard(
          'Monthly Avg',
          '\$${(data.yearlyGrandTotal.grandTotalPurchase / data.currentYearMonthlyPurchases.length).toStringAsFixed(2)}',
          Icons.trending_up,
          Colors.green,
        ),
        _buildMetricCard(
          'Top Products',
          data.topProducts.length.toString(),
          Icons.inventory_2,
          Colors.orange,
        ),
        _buildMetricCard(
          'Top Suppliers',
          data.topSuppliers.length.toString(),
          Icons.business,
          Colors.purple,
        ),
        _buildMetricCard(
          'Current Month',
          '\$${data.currentYearMonthlyPurchases.last.totalPurchase.toStringAsFixed(2)}',
          Icons.calendar_today,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProductsPieChart(PurchaseAnalyticsResponse data) {
    final top5Products = data.topProducts.take(5).toList();
    final total = top5Products.fold(0.0, (sum, product) => sum + product.totalPurchase);

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Products Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Top 5 products by purchase value',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            _currentPieChartIndex =
                                pieTouchResponse?.touchedSection?.touchedSectionIndex ?? -1;
                          });
                        },
                      ),
                      sections: top5Products
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final product = entry.value;
                        final isTouched = index == _currentPieChartIndex;
                        final fontSize = isTouched ? 16.0 : 14.0;
                        final radius = isTouched ? 60.0 : 50.0;

                        return PieChartSectionData(
                          color: _getChartColor(index),
                          value: (product.totalPurchase / total) * 100,
                          title: '${((product.totalPurchase / total) * 100).toStringAsFixed(1)}%',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: top5Products
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final product = entry.value;
                    final isTouched = index == _currentPieChartIndex;

                    return ListTile(
                      leading: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getChartColor(index),
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(
                        product.productName,
                        style: TextStyle(
                          fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
                          fontSize: isTouched ? 14 : 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        '\$${product.totalPurchase.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSuppliersChart(PurchaseAnalyticsResponse data) {
    final topSuppliers = data.topSuppliers.take(6).toList();

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Suppliers Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Top 6 suppliers by total purchase amount',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < topSuppliers.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                topSuppliers[index].supplierName.split(' ').first,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: topSuppliers
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final supplier = entry.value;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: supplier.totalPurchase,
                          gradient: LinearGradient(
                            colors: [

                              Colors.blue,
                              Colors.blue.shade300,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedLists(PurchaseAnalyticsResponse data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildExpandableSection('Top Products', data.topProducts, (item) => item.productName),
        const SizedBox(height: 16),
        _buildExpandableSection('Top Suppliers', data.topSuppliers, (item) => item.supplierName),
      ],
    );
  }

  Widget _buildExpandableSection<T>(String title, List<T> items, String Function(T) getName) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: items.map((item) => ListTile(
        title: Text(getName(item)),
        trailing: Text(
          '\$${(item as dynamic).totalPurchase.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      )).toList(),
    );
  }

  Color _getChartColor(int index) {
    final colors = [
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.red[400]!,
      Colors.purple[400]!,
      Colors.teal[400]!,
    ];
    return colors[index % colors.length];
  }

  final NumberFormat formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
}