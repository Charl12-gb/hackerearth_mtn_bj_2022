class RequestToPay{
  final String payer;
  final String payeeNote;
  final String payerMessage;
  final String externalId;
  final String currency;
  final String amount;
  final String status;
  final String financialTransactionId;

  const RequestToPay({
    required this.payer,
    required this.payeeNote,
    required this.payerMessage,
    required this.externalId,
    required this.currency,
    required this.amount,
    required this.status,
    required this.financialTransactionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'payer': this.payer,
      'payeeNote': this.payeeNote,
      'payerMessage': this.payerMessage,
      'externalId': this.externalId,
      'currency': this.currency,
      'amount': this.amount,
      'status': this.status,
      'financialTransactionId': this.financialTransactionId,
    };
  }

  factory RequestToPay.fromMap(Map<String, dynamic> map) {
    return RequestToPay(
      payer: map['payer'] as String,
      payeeNote: map['payeeNote'] as String,
      payerMessage: map['payerMessage'] as String,
      externalId: map['externalId'] as String,
      currency: map['currency'] as String,
      amount: map['amount'] as String,
      status: map['status'] as String,
      financialTransactionId: map['financialTransactionId'] as String,
    );
  }
}