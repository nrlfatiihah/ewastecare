class MaterialModel {
  // String id; // This is the rateId
  String name;
  double value;
  String type;

  MaterialModel({
    // required this.id,
    required this.name,
    required this.value,
    required this.type,
  });

  factory MaterialModel.fromMap(Map<String, dynamic> map) {
    return MaterialModel(
      // id: map['id'] ?? "",
      name: map['name'] ?? "",
      value: map['value']?.toDouble() ?? 0.0,
      type: map['type'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'value': value,
      'type': type,
    };
  }
}
