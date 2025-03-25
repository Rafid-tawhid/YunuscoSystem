import 'package:flutter/foundation.dart';

@immutable
class Menu {
  final int id;
  final String image;
  final String grayImage;
  final String name;
  final bool selected;
  final bool isVisible;

  const Menu({
    required this.id,
    required this.image,
    required this.grayImage,
    required this.name,
    this.selected = false,
    this.isVisible = true,
  });

  // Convert JSON to Menu object
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] as int? ?? 0,
      image: json['image'] as String? ?? '',
      grayImage: json['grayImage'] as String? ?? '',
      name: json['name'] as String? ?? '',
      selected: json['selected'] as bool? ?? false,
      isVisible: json['isVisible'] as bool? ?? true,
    );
  }

  // Convert Menu object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'grayImage': grayImage,
      'name': name,
      'selected': selected,
      'isVisible': isVisible,
    };
  }

  // CopyWith method for modifying instances
  Menu copyWith({
    int? id,
    String? image,
    String? grayImage,
    String? name,
    bool? selected,
    bool? isVisible,
  }) {
    return Menu(
      id: id ?? this.id,
      image: image ?? this.image,
      grayImage: grayImage ?? this.grayImage,
      name: name ?? this.name,
      selected: selected ?? this.selected,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  String toString() {
    return 'Menu(id: $id, name: $name, selected: $selected, isVisible: $isVisible)';
  }
}
