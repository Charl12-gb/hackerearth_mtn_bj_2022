class Account{
  final String id;
  final String userId;
  final String name;
  final double balance;
  final String description;
  final String withdrawalDate;
  final int createdAt;
  final int updatedAt;
  final Map<String, dynamic>? metadata;

  const Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.balance,
    required this.description,
    required this.withdrawalDate,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  Account copyWith({
    String? id,
    String? userId,
    String? name,
    double? balance,
    String? description,
    String? withdrawalDate,
    int? createdAt,
    int? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      description: description ?? this.description,
      withdrawalDate: withdrawalDate ?? this.withdrawalDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'userId': this.userId,
      'name': this.name,
      'balance': this.balance,
      'description': this.description,
      'withdrawalDate': this.withdrawalDate,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'metadata': this.metadata,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      balance: map['balance'] as double,
      description: map['description'] as String,
      withdrawalDate: map['withdrawalDate'] as String,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
      metadata: map['metadata'] as Map<String, dynamic>,
    );
  }
}