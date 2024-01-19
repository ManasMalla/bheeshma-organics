class Address {
  final String doorNumber;
  final String building;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String landmark;
  final String phoneNumber;
  final String name;
  final int id;
  final bool isDefault;
  final String type;
  final int distance;
  const Address({
    required this.doorNumber,
    required this.building,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    required this.landmark,
    required this.phoneNumber,
    required this.name,
    required this.id,
    this.isDefault = false,
    required this.type,
    required this.distance,
  });
}
