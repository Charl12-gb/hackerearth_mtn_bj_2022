import 'package:hackerearth_mtn_bj_2022/models/payer.dart';

class MomoTransaction{
  final String amount;
  final String currency;
  final String financialTransactionId;
  final String externalId;
  final Payer payer;
  final String status;
  final String reason;

  const MomoTransaction({
    required this.amount,
    required this.currency,
    required this.financialTransactionId,
    required this.externalId,
    required this.payer,
    required this.status,
    required this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': this.amount,
      'currency': this.currency,
      'financialTransactionId': this.financialTransactionId,
      'externalId': this.externalId,
      'payer': this.payer,
      'status': this.status,
      'reason': this.reason,
    };
  }

  factory MomoTransaction.fromMap(Map<String, dynamic> map) {
    return MomoTransaction(
      amount: map['amount'] as String,
      currency: map['currency'] as String,
      financialTransactionId: map['financialTransactionId'] as String,
      externalId: map['externalId'] as String,
      payer: Payer.fromMap(map['payer']),
      status: map['status'] as String,
      reason: map['reason'] as String,
    );
  }
}