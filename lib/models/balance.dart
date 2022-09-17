class Balance{
  final String description;
  final double availableBalance;
  final String currency;

  const Balance({
    required this.description,
    required this.availableBalance,
    required this.currency,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': this.description,
      'availableBalance': this.availableBalance,
      'currency': this.currency,
    };
  }

  factory Balance.fromMap(Map<String, dynamic> map) {
    return Balance(
      description: map['description'] as String,
      availableBalance: map['availableBalance'] as double,
      currency: map['currency'] as String,
    );
  }
}