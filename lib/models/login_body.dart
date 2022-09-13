class LoginBody{
  final String userId;
  final String apiKey;

  const LoginBody({
    required this.userId,
    required this.apiKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'apiKey': apiKey,
    };
  }

  factory LoginBody.fromMap(Map<String, dynamic> map) {
    return LoginBody(
      userId: map['userId'] as String,
      apiKey: map['apiKey'] as String,
    );
  }
}