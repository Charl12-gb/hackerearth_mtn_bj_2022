class AccessToken {
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  const AccessToken({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  Map<String, dynamic> toMap() {
    return {
      'accessToken': this.accessToken,
      'tokenType': this.tokenType,
      'expiresIn': this.expiresIn,
    };
  }

  factory AccessToken.fromMap(Map<String, dynamic> map) {
    return AccessToken(
      accessToken: map['accessToken'] as String,
      tokenType: map['tokenType'] as String,
      expiresIn: map['expiresIn'] as int,
    );
  }
  
  String getToken() {
    return accessToken;
  }
}