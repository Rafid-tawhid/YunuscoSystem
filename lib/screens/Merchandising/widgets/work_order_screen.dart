import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/merchandising_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

class WorkOrderScreen extends StatefulWidget {
  const WorkOrderScreen({super.key});

  @override
  State<WorkOrderScreen> createState() => _WorkOrderScreenState();
}

class _WorkOrderScreenState extends State<WorkOrderScreen> {
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  bool _isLoading = false; // Add this loading state variable

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? _fromDate : _toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  @override
  void initState() {
    getWorkOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Work Orders'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<MerchandisingProvider>(
        builder: (context, pro, _) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Date Range Selector
              Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'From Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _selectDate(context, true),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DateFormat('dd MMM yyyy').format(_fromDate)),
                                    const Icon(Icons.calendar_today, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'To Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _selectDate(context, false),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DateFormat('dd MMM yyyy').format(_toDate)),
                                    const Icon(Icons.calendar_today, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Fetch Button with loading indicator
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                    setState(() => _isLoading = true);
                    await pro.getAllWorkOrder(from: _fromDate, to: _toDate);
                    setState(() => _isLoading = false);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: myColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                      :  Text(
                    'Get Work Orders',
                    style: customTextStyle(14, Colors.white, FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Results
              Expanded(
                child: pro.workOrderList.isEmpty
                    ? Center(
                  child: Text(
                    pro.workOrderList.isEmpty
                        ? 'No work orders found for selected date range'
                        : 'Select dates and tap the button',
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: pro.workOrderList.length,
                  itemBuilder: (context, index) {
                    final order = pro.workOrderList[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.code ?? 'N/A',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    order.isLock ?? false
                                        ? 'Locked'
                                        : 'Active',
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                  backgroundColor: order.isLock ?? false
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('PO: ${order.po ?? 'N/A'}'),
                            Text('Buyer: ${order.buyerName ?? 'N/A'}'),
                            Text('Style: ${order.styleCodes ?? 'N/A'}'),
                            Text('Color: ${order.color ?? 'N/A'}'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Created: ${order.createdDate ?? 'N/A'}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                Spacer(),
                                TextButton(onPressed: (){
                                  DashboardHelpers.openUrl('http://202.74.243.118:1726/Merchandising/Merchandising/WorkOrderReport?Code=${order.code}&Buyer=${order.buyerId}&BuyerOrder=${order.blockOrder}');
                                }, child: Text('Report'))
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getWorkOrder() async {
    var mp = context.read<MerchandisingProvider>();
    setState(() => _isLoading = true);
    await mp.getAllWorkOrder(from:_fromDate, to: _toDate);
    setState(() => _isLoading = false);
  }
}