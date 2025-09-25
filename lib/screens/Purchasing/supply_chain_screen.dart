// approved_requisitions_screen.dart
import 'package:flutter/material.dart';
import 'package:yunusco_group/providers/purchase_provider.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/screens/Purchasing/supply_chain_report_screen.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../models/approval_Supply_model.dart';
import '../../models/puchaseMasterModelFirebase.dart';
import 'cs_create_screen.dart';

class ApprovedRequisitionsScreen extends StatefulWidget {
  @override
  _ApprovedRequisitionsScreenState createState() => _ApprovedRequisitionsScreenState();
}

class _ApprovedRequisitionsScreenState extends State<ApprovedRequisitionsScreen> {

  List<ApprovedRequisition> _approvedRequisitions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApprovedRequisitions();
  }

  Future<void> _loadApprovedRequisitions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var pp=context.read<PurchaseProvider>();
      final requisitions = await pp.getApprovedRequisitions();
      setState(() {
        _approvedRequisitions = requisitions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error loading approved requisitions: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
  }

  void _navigateToSupplyChainScreen(ApprovedRequisition requisition, RequisitionDetail detail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupplyChainFormScreen(
          requisition: requisition,
          productDetail: detail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supply Chain'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.list),onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SupplyChainRecordsScreen()));
          },),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _approvedRequisitions.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No approved requisitions found', style: TextStyle(fontSize: 18)),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadApprovedRequisitions,
        child: ListView.builder(
          itemCount: _approvedRequisitions.length,
          itemBuilder: (context, index) {
            final requisition = _approvedRequisitions[index];
            return ApprovedRequisitionCard(
              requisition: requisition,
              onProductTap: _navigateToSupplyChainScreen,
            );
          },
        ),
      ),
    );
  }
}

class ApprovedRequisitionCard extends StatelessWidget {
  final ApprovedRequisition requisition;
  final Function(ApprovedRequisition, RequisitionDetail) onProductTap;

  const ApprovedRequisitionCard({
    Key? key,
    required this.requisition,
    required this.onProductTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: ExpansionTile(
        leading: Icon(Icons.inventory, color: Colors.green),
        title: Text('Req #${requisition.reqId.substring(requisition.reqId.length - 6)}'),
        subtitle: Text('Products: ${requisition.details.length}'),
        children: [
          ...requisition.details.map((detail) => ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.blue),
            title: Text(detail.productName),
            subtitle: Text('Qty: ${detail.totalReqQty} | Brand: ${detail.brand}'),
            trailing: Chip(
              label: Text('Add Supplier', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue,
            ),
            onTap: () => onProductTap(requisition, detail),
          )),
        ],
      ),
    );
  }
}