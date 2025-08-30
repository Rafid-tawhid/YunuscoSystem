import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';

class SelectedPeopleWidget extends StatelessWidget {
  const SelectedPeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HrProvider>(context);
    final selectedMembers =
        provider.member_list.where((m) => m.isSelected).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedMembers.isNotEmpty)
          Text(
            'Selected People:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        if (selectedMembers.isEmpty)
          SizedBox.shrink()
        else
          Wrap(
            spacing: 4,
            children: selectedMembers.map((member) {
              return Chip(
                backgroundColor: Colors.white,
                label: Text(
                  member.fullName ?? '',
                  style: TextStyle(fontSize: 10),
                ),
                avatar: CircleAvatar(
                  backgroundColor: Colors.blue.shade300,
                  child: Text(
                    member.fullName ?? ''.substring(0, 1),
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  provider.toggleSelection(provider.member_list
                      .indexWhere((m) => m.idCardNo == member.idCardNo));
                },
              );
            }).toList(),
          ),
      ],
    );
  }
}
