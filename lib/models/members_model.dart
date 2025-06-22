class MembersModel {
  final String id;
  final String name;
  final String department;
  final String designation;
  bool isSelected;

  MembersModel({
    required this.id,
    required this.name,
    required this.department,
    required this.designation,
    this.isSelected = false,
  });
}