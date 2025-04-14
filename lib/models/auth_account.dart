class AuthAccount {
  final String id;
  final String issuer;
  final String email;
  final String secret;

  AuthAccount({
    required this.id,
    required this.issuer,
    required this.email,
    required this.secret,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'issuer': issuer,
        'email': email,
        'secret': secret,
      };

  static AuthAccount fromJson(Map<String, dynamic> json) => AuthAccount(
        id: json['id'],
        issuer: json['issuer'],
        email: json['email'],
        secret: json['secret'],
      );
}
