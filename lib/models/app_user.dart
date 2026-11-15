class AppUser {
  const AppUser({required this.name, required this.email});

  final String name;
  final String email;

  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final email = json['email'];
    if (name is! String || email is! String) {
      throw const FormatException('Data sesi pengguna tidak valid.');
    }
    return AppUser(name: name, email: email);
  }
}
