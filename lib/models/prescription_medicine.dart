class PrescriptionMedicine {
  final String productName;
  final num medicineId;
  final num? medicineType;
  final int quantity;
  final String? note;
  final String? advice;
  final String? medicineContinue;

  PrescriptionMedicine({
    required this.productName,
    required this.medicineId,
    this.medicineType,
    required this.quantity,
    this.note,
    this.advice,
    this.medicineContinue,
  });

  factory PrescriptionMedicine.fromJson(Map<String, dynamic> json) {
    return PrescriptionMedicine(
      productName: json['productName'],
      medicineId: json['medicineId'],
      medicineType: json['madicineType'],
      quantity: json['quantity'],
      note: json['note'],
      advice: json['advice'],
      medicineContinue: json['madicineContinue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'medicineId': medicineId,
      'madicineType': medicineType,
      'quantity': quantity,
      'note': note,
      'advice': advice,
      'madicineContinue': medicineContinue,
    };
  }

  PrescriptionMedicine copyWith({
    String? productName,
    num? medicineId,
    num? medicineType,
    int? quantity,
    String? note,
    String? advice,
    String? medicineContinue,
  }) {
    return PrescriptionMedicine(
      productName: productName ?? this.productName,
      medicineId: medicineId ?? this.medicineId,
      medicineType: medicineType ?? this.medicineType,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      advice: advice ?? this.advice,
      medicineContinue: medicineContinue ?? this.medicineContinue,
    );
  }

  @override
  String toString() {
    return 'PrescriptionMedicine(productName: $productName, medicineId: $medicineId, medicineType: $medicineType, quantity: $quantity, note: $note, advice: $advice, medicineContinue: $medicineContinue)';
  }
}
