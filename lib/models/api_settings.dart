class ApiSettings{
  final String id;
  final String baseUrl;
  final String environment;
  final String currency;
  final String callbackHost;
  final String collectionPrimaryKey;
  final String collectionUserId;
  final String collectionApiSecret;
  final String remittanceUserId;
  final String remittanceApiSecret;
  final String remittancePrimaryKey;
  final String disbursementUserId;
  final String disbursementApiSecret;
  final String disbursementPrimaryKey;
  final int createdAt;
  final int updatedAt;
  final Map<String, dynamic>? metadata;

  const ApiSettings({
    required this.id,
    required this.baseUrl,
    required this.environment,
    required this.currency,
    required this.callbackHost,
    required this.collectionPrimaryKey,
    required this.collectionUserId,
    required this.collectionApiSecret,
    required this.remittanceUserId,
    required this.remittanceApiSecret,
    required this.remittancePrimaryKey,
    required this.disbursementUserId,
    required this.disbursementApiSecret,
    required this.disbursementPrimaryKey,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  ApiSettings copyWith({
    String? id,
    String? baseUrl,
    String? environment,
    String? currency,
    String? callbackHost,
    String? collectionPrimaryKey,
    String? collectionUserId,
    String? collectionApiSecret,
    String? remittanceUserId,
    String? remittanceApiSecret,
    String? remittancePrimaryKey,
    String? disbursementUserId,
    String? disbursementApiSecret,
    String? disbursementPrimaryKey,
    int? createdAt,
    int? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ApiSettings(
      id: id ?? this.id,
      baseUrl: baseUrl ?? this.baseUrl,
      environment: environment ?? this.environment,
      currency: currency ?? this.currency,
      callbackHost: callbackHost ?? this.callbackHost,
      collectionPrimaryKey: collectionPrimaryKey ?? this.collectionPrimaryKey,
      collectionUserId: collectionUserId ?? this.collectionUserId,
      collectionApiSecret: collectionApiSecret ?? this.collectionApiSecret,
      remittanceUserId: remittanceUserId ?? this.remittanceUserId,
      remittanceApiSecret: remittanceApiSecret ?? this.remittanceApiSecret,
      remittancePrimaryKey: remittancePrimaryKey ?? this.remittancePrimaryKey,
      disbursementUserId: disbursementUserId ?? this.disbursementUserId,
      disbursementApiSecret:
          disbursementApiSecret ?? this.disbursementApiSecret,
      disbursementPrimaryKey:
          disbursementPrimaryKey ?? this.disbursementPrimaryKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'baseUrl': this.baseUrl,
      'environment': this.environment,
      'currency': this.currency,
      'callbackHost': this.callbackHost,
      'collectionPrimaryKey': this.collectionPrimaryKey,
      'collectionUserId': this.collectionUserId,
      'collectionApiSecret': this.collectionApiSecret,
      'remittanceUserId': this.remittanceUserId,
      'remittanceApiSecret': this.remittanceApiSecret,
      'remittancePrimaryKey': this.remittancePrimaryKey,
      'disbursementUserId': this.disbursementUserId,
      'disbursementApiSecret': this.disbursementApiSecret,
      'disbursementPrimaryKey': this.disbursementPrimaryKey,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'metadata': this.metadata,
    };
  }

  factory ApiSettings.fromMap(Map<String, dynamic> map) {
    return ApiSettings(
      id: map['id'] as String,
      baseUrl: map['baseUrl'] as String,
      environment: map['environment'] as String,
      currency: map['currency'] as String,
      callbackHost: map['callbackHost'] as String,
      collectionPrimaryKey: map['collectionPrimaryKey'] as String,
      collectionUserId: map['collectionUserId'] as String,
      collectionApiSecret: map['collectionApiSecret'] as String,
      remittanceUserId: map['remittanceUserId'] as String,
      remittanceApiSecret: map['remittanceApiSecret'] as String,
      remittancePrimaryKey: map['remittancePrimaryKey'] as String,
      disbursementUserId: map['disbursementUserId'] as String,
      disbursementApiSecret: map['disbursementApiSecret'] as String,
      disbursementPrimaryKey: map['disbursementPrimaryKey'] as String,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
      metadata: map['metadata'] as Map<String, dynamic>,
    );
  }
}