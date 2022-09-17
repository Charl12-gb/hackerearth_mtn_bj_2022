import 'package:hackerearth_mtn_bj_2022/models/payer.dart';

class MomoTransaction{
  final String amount;
  final String currency;
  final String financialTransactionId;
  final String externalId;
  final String payerMessage;
  final String payeeNote;
  final Payer payer;
  final String status;
  final String reason;

  const MomoTransaction({
    required this.amount,
    required this.currency,
    required this.financialTransactionId,
    required this.externalId,
    required this.payerMessage,
    required this.payeeNote,
    required this.payer,
    required this.status,
    required this.reason,
  });

  MomoTransaction copyWith({
    String? amount,
    String? currency,
    String? financialTransactionId,
    String? externalId,
    String? payerMessage,
    String? payeeNote,
    Payer? payer,
    String? status,
    String? reason,
  }) {
    return MomoTransaction(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      financialTransactionId:
          financialTransactionId ?? this.financialTransactionId,
      externalId: externalId ?? this.externalId,
      payerMessage: payerMessage ?? this.payerMessage,
      payeeNote: payeeNote ?? this.payeeNote,
      payer: payer ?? this.payer,
      status: status ?? this.status,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': this.amount,
      'currency': this.currency,
      'financialTransactionId': this.financialTransactionId,
      'externalId': this.externalId,
      'payerMessage': this.payerMessage,
      'payeeNote': this.payeeNote,
      'payer': this.payer.toMap(),
      'status': this.status,
      'reason': this.reason,
    };
  }

  factory MomoTransaction.fromMap(Map<String, dynamic> map) {
    return MomoTransaction(
      amount: map['amount'] as String,
      currency: map['currency'] as String,
      financialTransactionId: map['financialTransactionId']??"",
      externalId: map['externalId'] as String,
      payerMessage: map['payerMessage']??"",
      payeeNote: map['payeeNote']??"",
      payer:  Payer.fromMap(map['payer']),
      status: map['status'] as String,
      reason: map['reason']??"",
    );
  }
}