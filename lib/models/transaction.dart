import 'enums.dart';

class Transaction{
  final String id;
  final String uuid;
  final String currency;
  final String userId;
  final String accountId;
  final double amount;
  final TransactionStatus status;
  final TransactionType type;
  final int createdAt;
  final int updatedAt;
  final Map<String, dynamic>? metadata;

  const Transaction({
    required this.id,
    required this.uuid,
    required this.currency,
    required this.userId,
    required this.accountId,
    required this.amount,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  Transaction copyWith({
    String? id,
    String? uuid,
    String? currency,
    String? userId,
    String? accountId,
    double? amount,
    TransactionStatus? status,
    TransactionType? type,
    int? createdAt,
    int? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Transaction(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      currency: currency ?? this.currency,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'uuid': this.uuid,
      'currency': this.currency,
      'userId': this.userId,
      'accountId': this.accountId,
      'amount': this.amount,
      'status': this.status,
      'type': this.type,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'metadata': this.metadata,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      uuid: map['uuid'] as String,
      currency: map['currency'] as String,
      userId: map['userId'] as String,
      accountId: map['accountId'] as String,
      amount: map['amount'] as double,
      status: map['status'] as TransactionStatus,
      type: map['type'] as TransactionType,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
      metadata: map['metadata'] as Map<String, dynamic>,
    );
  }
}