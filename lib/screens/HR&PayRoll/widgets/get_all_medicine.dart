import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import '../../../models/medicine_model.dart';


class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HrProvider>(context, listen: false).getAllMedicine();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Provider.of<HrProvider>(context, listen: false)
        .filterMedicines(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final medicinesProvider = Provider.of<HrProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search medicines...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: _searchController,
          //     decoration: InputDecoration(
          //       hintText: 'Search medicines...',
          //       prefixIcon: const Icon(Icons.search),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: medicinesProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildMedicineList(medicinesProvider.filteredMedicines),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineList(List<MedicineModel> medicines) {
    if (medicines.isEmpty) {
      return const Center(child: Text('No medicines found'));
    }

    return ListView.builder(
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        final medicine = medicines[index];
        return _MedicineListItem(medicine: medicine);
      },
    );
  }
}

class _MedicineListItem extends StatelessWidget {
  final MedicineModel medicine;

  const _MedicineListItem({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.medication, color: Colors.blue),
        title: Text(medicine.productName ?? 'No Name'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code: ${medicine.productCode ?? 'N/A'}'),
            Text('Base: ${medicine.baseName ?? 'N/A'}'),
          ],
        ),
        trailing: Text('#${medicine.productId?.toString() ?? ''}'),
        onTap: () {
          // Handle medicine selection
        },
      ),
    );
  }
}