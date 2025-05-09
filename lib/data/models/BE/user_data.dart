class UserData {
  String name;
  String email;
  // String phone;
  String membership;
  String address;
  String profilePictureUrl;

  UserData({
    required this.name,
    required this.email,
    // required this.phone,
    required this.membership,
    required this.address,
    required this.profilePictureUrl,
  });

  // Map from json to UserData
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['username'] ?? '',
      email: json['email'] ?? '',
      membership: json['role'] ?? '',
      address: json['address'] ?? '',
      profilePictureUrl: json['picture'] ?? '',
    );
  }
}
