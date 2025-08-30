import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/screens/Products/style_wise_efficiency_screen.dart';

import '../../helper_class/dashboard_helpers.dart';
import '../../utils/constants.dart';

class StyleSelectionScreen extends StatefulWidget {
  const StyleSelectionScreen({super.key});

  @override
  _StyleSelectionScreenState createState() => _StyleSelectionScreenState();
}

class _StyleSelectionScreenState extends State<StyleSelectionScreen> {
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterStyles(String query) {
    var bp = context.read<ProductProvider>();
    bp.searchInStyleList(query);
  }

  Future<void> _handleSelection(int index, data) async {
    var pp = context.read<ProductProvider>();
    await pp.getStyleWiseEfficiency(data ?? '');
    if (pp.styleWiseEfficiencyList.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StylewiseEfficiencyScreen(
                  efficiencies: pp.styleWiseEfficiencyList,
                )),
      );
    } else {
      DashboardHelpers.showAlert(msg: 'No Data Found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Search styles...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black)),
                style: TextStyle(color: Colors.black),
                onChanged: filterStyles,
              )
            : Text('Select Style',
                style: AppConstants.customTextStyle(
                    18, Colors.black, FontWeight.w500)),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  isSearching = false;
                  searchController.clear();
                });
                var pp = context.read<ProductProvider>();
                pp.filteredStyleList.clear();
                pp.filteredStyleList.addAll(pp.buyerStyleList);
              },
            ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, pro, _) => pro.filteredStyleList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 50, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No styles found',
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Text('Try a different search term',
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[500])),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: pro.filteredStyleList.length,
                itemBuilder: (context, index) {
                  final style = pro.filteredStyleList[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () => _handleSelection(index, style),
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: isSelected
                              ? BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)
                              : BorderSide.none),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle),
                              child: Icon(Icons.style,
                                  size: 30,
                                  color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                style ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
