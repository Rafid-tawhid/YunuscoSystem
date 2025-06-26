import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExportRegisterScreen extends StatelessWidget {
  const ExportRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Export Register Report',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Category Section (unchanged)
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Report Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        )),
                    const SizedBox(height: 12),
                    _buildCategoryItem('C Export Register'),
                    _buildCategoryItem('C Export Register Details'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Search Options Section - IMPROVED
            const Text('Search Options',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                )),

            const SizedBox(height: 16),

            // Improved search options
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Row 1
                    _buildSearchRow([
                      _buildSearchField('Buyer Name', hasDropdown: true),
                      _buildSearchField('Item', hasDropdown: true),
                    ]),

                    const SizedBox(height: 16),

                    // Row 2
                    _buildSearchRow([
                      _buildSearchField('Code'),
                      _buildSearchField('GetPass'),
                    ]),

                    const SizedBox(height: 16),

                    // Row 3
                    _buildSearchRow([
                      _buildSearchField('PO'),
                      _buildSearchField('Driver Cell No'),
                    ]),

                    const SizedBox(height: 16),

                    // Row 4
                    _buildSearchRow([
                      _buildSearchField('Chalan No'),
                      const SizedBox(), // Empty space to maintain grid
                    ]),

                    const SizedBox(height: 16),

                    // Date fields
                    _buildDateFieldRow('Ex-Factory Date'),
                    const SizedBox(height: 12),
                    _buildDateFieldRow('In-Time Date'),
                    const SizedBox(height: 12),
                    _buildDateFieldRow('Out-Time Date'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons (unchanged)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.preview, size: 18),
                  label: const Text('Preview Report'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Excel Export'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods...

  Widget _buildCategoryItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.blue),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSearchRow(List<Widget> children) {
    return Row(
      children: [
        Expanded(child: children[0]),
        const SizedBox(width: 16),
        Expanded(child: children[1]),
      ],
    );
  }

  Widget _buildSearchField(String label, {bool hasDropdown = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: false,
              onChanged: (v) {},
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 4),
        if (hasDropdown)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'Select', child: Text('Select ▼')),
            ],
            onChanged: (value) {},
          )
        else
          const TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDateFieldRow(String label) {
    return Row(
      children: [
        Checkbox(
            value: false,
            onChanged: (v) {},
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.calendar_today, size: 18),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text('To', style: TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.calendar_today, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
