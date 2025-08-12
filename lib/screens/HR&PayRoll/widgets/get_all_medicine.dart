import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/common_widgets/custom_button.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import '../../../models/medicine_model.dart';
import '../../../models/prescription_medicine.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllMedicine();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Provider.of<HrProvider>(context, listen: false).filterMedicines(_searchController.text);
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      } else {
        // Focus on the search field when it appears
        FocusScope.of(context).requestFocus(FocusNode());
        Future.delayed(Duration.zero, () {
          FocusScope.of(context).requestFocus(FocusNode());
          FocusScope.of(context).requestFocus(_searchFocusNode);
        });
      }
    });
  }

  final FocusNode _searchFocusNode = FocusNode();

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search medicines...',
        border: InputBorder.none,
      ),
      style: const TextStyle(fontSize: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medicinesProvider = Provider.of<HrProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : const Text('Medicines', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isSearching
                ? IconButton(
              key: const ValueKey('close'),
              onPressed: _toggleSearch,
              icon: const Icon(Icons.close),
            )
                : IconButton(
              key: const ValueKey('search'),
              onPressed: _toggleSearch,
              icon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: medicinesProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildMedicineList(medicinesProvider.filteredMedicines),
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

  Future<void> getAllMedicine() async{
    var hp=context.read<HrProvider>();
    if(hp.medicines.isEmpty){
      hp.getAllMedicine();
    }
  }
}

class _MedicineListItem extends StatelessWidget {
  final MedicineModel medicine;

  const _MedicineListItem({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
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
        onTap: () async {
          final result = await showMedicineDetailsBottomSheet(context, medicine);
          if (result != null) {
            //{medicineId: 2950, madicineType: 18, quantity: 3, note: nothing, advice: take rest, madicineContinue: 3}
            // Handle the result data here
            var hp=context.read<HrProvider>();
            PrescriptionMedicine medicine= PrescriptionMedicine.fromJson(result);
            hp.addMedicineListForPrescription(medicine);
            // If you want to pop the current screen after getting the result:
            Navigator.pop(context, result);
          }
        },
      ),
    );
  }


  Future<Map<String, dynamic>?> showMedicineDetailsBottomSheet(
      BuildContext context,
      MedicineModel medicine,
      ) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _quantityController = TextEditingController();
    final TextEditingController _daysController = TextEditingController();

    // Dropdown and checkbox state
    String _selectedTime = '0+0+1';
    bool _medicineStatus = false;

    final List<String> medicineTimes = ['0+0+1', '0+1+0', '0+1+1', '1+0+0','1+0+1','1+1+0','1+1+1'];

    return await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      medicine.productName ?? 'Medicine Details',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Quantity
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity*',
                        border: OutlineInputBorder(),
                        hintText: 'Enter quantity',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Medicine Time (Dropdown)
                    DropdownButtonFormField<String>(
                      value: _selectedTime,
                      decoration: const InputDecoration(
                        labelText: 'Medicine Time',
                        border: OutlineInputBorder(),
                      ),
                      items: medicineTimes.map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedTime = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Medicine Status (Radio Buttons using bool)
                    const Text(
                      "Medicine Status",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    RadioListTile<bool>(
                      title: const Text("Before"),
                      value: true,
                      groupValue: _medicineStatus,
                      onChanged: (value) {
                        setState(() {
                          _medicineStatus = value!;
                        });
                      },
                    ),
                    RadioListTile<bool>(
                      title: const Text("After"),
                      value: false,
                      groupValue: _medicineStatus,
                      onChanged: (value) {
                        setState(() {
                          _medicineStatus = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Continue Days
                    TextFormField(
                      controller: _daysController,
                      decoration: const InputDecoration(
                        labelText: 'Continue for (e.g., 2 days)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      text: 'Add+',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final data = {
                            "productName": medicine.productName,
                            "medicineId": medicine.productId,
                            "madicineType": medicine.productTypeId,
                            "quantity": int.parse(_quantityController.text),
                            "madicineContinue": _daysController.text,
                            "medicineTime": _selectedTime,
                            "medicineStatus": _medicineStatus,
                          };
                          Navigator.pop(context, data);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

}