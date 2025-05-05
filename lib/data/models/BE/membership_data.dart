import 'dart:ffi';

class MembershipData {
  String id;
  String name;
  String description;
  double discount;
  int price;
  int duration;
  String createdAt;
  String updatedAt;
  List<String>? features;

  MembershipData({
    required this.id,
    required this.name,
    required this.description,
    required this.discount,
    required this.price,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    this.features,
  });
}
