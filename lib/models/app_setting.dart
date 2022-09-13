class AppSettings{
  final String id;
  final double minDeposit;
  final double penaltyChargePercent;
  final int minWithdrawalDate;
  final int createdAt;
  final int updatedAt;
  final Map<String, dynamic>? metadata;

  const AppSettings({
    required this.id,
    required this.minDeposit,
    required this.penaltyChargePercent,
    required this.minWithdrawalDate,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  AppSettings copyWith({
    String? id,
    double? minDeposit,
    double? penaltyChargePercent,
    int? minWithdrawalDate,
    String? targetEnvironment,
    int? createdAt,
    int? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return AppSettings(
      id: id ?? this.id,
      minDeposit: minDeposit ?? this.minDeposit,
      penaltyChargePercent: penaltyChargePercent ?? this.penaltyChargePercent,
      minWithdrawalDate: minWithdrawalDate ?? this.minWithdrawalDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'minDeposit': this.minDeposit,
      'penaltyChargePercent': this.penaltyChargePercent,
      'minWithdrawalDate': this.minWithdrawalDate,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'metadata': this.metadata,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      id: map['id'] as String,
      minDeposit: map['minDeposit'] as double,
      penaltyChargePercent: map['penaltyChargePercent'] as double,
      minWithdrawalDate: map['minWithdrawalDate'] as int,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
      metadata: map['metadata'] as Map<String, dynamic>,
    );
  }
}