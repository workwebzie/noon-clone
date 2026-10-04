class UserAddress {
  final String id;
  final String label; // e.g. Home, Office
  final String recipientName;
  final String phone;
  final String street;
  final String building;
  final String city;
  final String emirate; // e.g., Dubai, Abu Dhabi, Riyadh
  final bool isDefault;

  UserAddress({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.street,
    required this.building,
    required this.city,
    required this.emirate,
    this.isDefault = false,
  });

  String get fullAddress => '$building, $street, $city, $emirate';
}
