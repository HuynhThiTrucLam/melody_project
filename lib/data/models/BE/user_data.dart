class UserData {
  String id;
  String name;
  String email;
  String phone;
  String membership;
  String address;
  String profilePictureUrl;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.membership,
    required this.address,
    required this.profilePictureUrl,
  });

  // Mock user data
  static final UserData currentUser = UserData(
    id: '1234567890',
    name: 'John Doe',
    email: 'jonh@gmail.com',
    phone: '1234567890',
    membership: 'Premium',
    address: '123 Main St, City, Country',
    profilePictureUrl: 'assets/images/Avatar.png',
  );
}
