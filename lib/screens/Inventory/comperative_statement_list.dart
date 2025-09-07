import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/models/css_model.dart';
import 'package:yunusco_group/providers/inventory_provider.dart';
import 'package:yunusco_group/utils/colors.dart';

class ComperativeStatementList extends StatefulWidget {
  const ComperativeStatementList({super.key});

  @override
  State<ComperativeStatementList> createState() => _ComperativeStatementListState();
}

class _ComperativeStatementListState extends State<ComperativeStatementList> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    var ip = context.read<InventoryPorvider>();
    WidgetsBinding.instance.addPostFrameCallback((v){
      ip.getAllCs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : const Text('Comparative Statements'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: _buildAppBarActions(),
      ),
      body: Consumer<InventoryPorvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.filteredRequisitions.isEmpty) {
            return const Center(
              child: Text(
                'No matching CS found',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0,right: 8),
                child: Text('Total : ${provider.filteredRequisitions.length}'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.filteredRequisitions.length,
                  itemBuilder: (context, index) {
                    final requisition = provider.filteredRequisitions[index];
                    return RequisitionCard(requisition: requisition);
                  },
                ),
              ),
            ],
          );
        },
      ),

    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _searchController.clear();
              context.read<InventoryPorvider>().setSearchQuery('');
              _isSearching = false;
            });
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ];
    }
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        context.read<InventoryPorvider>().setSearchQuery(value);
      },
    );
  }

}

class RequisitionCard extends StatelessWidget {
  final CssModel requisition;

  const RequisitionCard({super.key, required this.requisition});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              requisition.purchaseRequisitionCode ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              requisition.userName ?? '',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                _buildChip(requisition.purchaseType ?? '',
                    Colors.blue[100]!, Colors.blue[800]!),
                const SizedBox(width: 8),
                _buildChip(requisition.type ?? '',
                    Colors.green[100]!, Colors.green[800]!),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              requisition.code ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              requisition.createdDate ?? '',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 12),
      ),
    );
  }
}

