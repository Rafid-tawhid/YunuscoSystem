import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';

class PersonSelectionScreen extends StatefulWidget {
  const PersonSelectionScreen({super.key});

  @override
  State<PersonSelectionScreen> createState() => _PersonSelectionScreenState();
}

class _PersonSelectionScreenState extends State<PersonSelectionScreen> {

  @override
  void initState() {
    getAllStuffMemberList();
    super.initState();
  }
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
                  title: Text(person.fullName??''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dept: ${person.departmentName}'),
                      Text('Designation: ${person.designationName}'),
                    ],
                  ),
                  value: person.isSelected,
                  onChanged: (bool? value) {
                    provider.toggleSelection(index);
                  },
                  secondary: CircleAvatar(
                    child: Text(person.fullName.toString().substring(0, 1)),
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

    Future<void> getAllStuffMemberList() async{
    var hp=context.read<HrProvider>();
    if(hp.member_list.isEmpty){
      hp.getAllStuffList();
    }



  }
}