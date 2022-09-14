class ApiUser{
  final String uuid;
  final String apiKey;

  const ApiUser({
    required this.uuid,
    required this.apiKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'apiKey': apiKey,
    };
  }

  factory ApiUser.fromMap(Map<String, dynamic> map) {
    return ApiUser(
      uuid: map['uuid'] as String,
      apiKey: map['apiKey'] as String,
    );
  }
}