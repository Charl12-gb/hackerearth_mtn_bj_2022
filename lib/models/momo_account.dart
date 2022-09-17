class MomoAccount{
  final String availableBalance;
  final String currency;

  const MomoAccount({
    required this.availableBalance,
    required this.currency,
  });

  MomoAccount copyWith({
    String? availableBalance,
    String? currency,
  }) {
    return MomoAccount(
      availableBalance: availableBalance ?? this.availableBalance,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'availableBalance': this.availableBalance,
      'currency': this.currency,
    };
  }

  factory MomoAccount.fromMap(Map<String, dynamic> map) {
    return MomoAccount(
      availableBalance: map['availableBalance'] as String,
      currency: map['currency'] as String,
    );
  }
}