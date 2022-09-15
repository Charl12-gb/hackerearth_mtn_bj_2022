import 'package:hackerearth_mtn_bj_2022/models/payer.dart';

class Transfer{
  final Payer payee;
  final String payeeNote;
  final String payerMessage;
  final String externalId;
  final String currency;
  final String amount;

  const Transfer({
    required this.payee,
    required this.payeeNote,
    required this.payerMessage,
    required this.externalId,
    required this.currency,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'payee': this.payee.toMap(),
      'payeeNote': this.payeeNote,
      'payerMessage': this.payerMessage,
      'externalId': this.externalId,
      'currency': this.currency,
      'amount': this.amount,
    };
  }

  factory Transfer.fromMap(Map<String, dynamic> map) {
    return Transfer(
      payee: Payer.fromMap(map['payee']),
      payeeNote: map['payeeNote']??"",
      payerMessage: map['payerMessage']??"",
      externalId: map['externalId'] as String,
      currency: map['currency'] as String,
      amount: map['amount'] as String,
    );
  }

  Transfer copyWith({
    Payer? payee,
    String? payeeNote,
    String? payerMessage,
    String? externalId,
    String? currency,
    String? amount,
  }) {
    return Transfer(
      payee: payee ?? this.payee,
      payeeNote: payeeNote ?? this.payeeNote,
      payerMessage: payerMessage ?? this.payerMessage,
      externalId: externalId ?? this.externalId,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
    );
  }
}