class Payer{
  final String partyIdType;
  final String partyId;

  const Payer({
    required this.partyIdType,
    required this.partyId,
  });

  Map<String, dynamic> toMap() {
    return {
      'partyIdType': this.partyIdType,
      'partyId': this.partyId,
    };
  }

  factory Payer.fromMap(Map<String, dynamic> map) {
    return Payer(
      partyIdType: map['partyIdType'] as String,
      partyId: map['partyId'] as String,
    );
  }

  Payer copyWith({
    String? partyIdType,
    String? partyId,
  }) {
    return Payer(
      partyIdType: partyIdType ?? this.partyIdType,
      partyId: partyId ?? this.partyId,
    );
  }
}