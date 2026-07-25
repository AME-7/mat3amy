class AuthParams {
  final String? name;
  final String email;
  final String password;
  final String role;

  AuthParams({
    this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}
