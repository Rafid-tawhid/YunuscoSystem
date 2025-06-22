import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';

class PersonSelectionScreen extends StatelessWidget {
  const PersonSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Persons'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              // Just close the screen when done is pressed
              Navigator.pop(context);
            },
            tooltip: 'Done',
          ),
        ],
      ),
      body: Consumer<HrProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.member_list.length,
            itemBuilder: (context, index) {
              final person = provider.member_list[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: CheckboxListTile(
                  title: Text(person.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dept: ${person.department}'),
                      Text('Designation: ${person.designation}'),
                    ],
                  ),
                  value: person.isSelected,
                  onChanged: (bool? value) {
                    provider.toggleSelection(index);
                  },
                  secondary: CircleAvatar(
                    child: Text(person.name.substring(0, 1)),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.green.shade300),
        ),
        onPressed: () {
          // Just close the screen when save is pressed
          Navigator.pop(context);
        },
        tooltip: 'Save',
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}