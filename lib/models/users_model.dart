class User {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final String phone;
  final String dob;
  final String country;
  final int followers;
  bool isBlocked;
  bool isApproved;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.phone,
    required this.dob,
    required this.country,
    required this.followers,
    required this.isBlocked,
    required this.isApproved,
  });

  factory User.fromFirestore(Map<String, dynamic> data, String documentId) {
    return User(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImage: data['profile'] ?? '',
      phone: data['phone'] ?? '',
      dob: data['dob'] ?? '',
      country: data['country'] ?? '',
      followers: data['followers'] ?? '',
      isBlocked: data['isBlocked'] ?? false,
      isApproved: data['isApproved'] ?? true,
    );
  }
}
