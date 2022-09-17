class FirebaseCoreConfig {
  const FirebaseCoreConfig({
    this.firebaseAppName,
    required this.usersCollectionName,
    required this.transactionCollectionName,
    required this.appSettingCollectionName,
    required this.apiSettingCollectionName,
    required this.accountCollectionName,
  });

  /// Property to set custom firebase app name
  final String? firebaseAppName;

  /// Property to set users collection name
  final String usersCollectionName;
  final String transactionCollectionName;
  final String appSettingCollectionName;
  final String apiSettingCollectionName;
  final String accountCollectionName;
}
