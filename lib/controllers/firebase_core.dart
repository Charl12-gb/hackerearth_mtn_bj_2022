import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/momoapi/collection.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/momoapi/disbursement.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/utils/utils.dart';
import 'package:hackerearth_mtn_bj_2022/models/enums.dart';

import 'package:hackerearth_mtn_bj_2022/models/models.dart' as models;
import 'config.dart';

/// Provides access to Firebase chat data. Singleton, use
/// FirebaseChatCore.instance to access methods.
class FirebaseCore{
  /// Current logged in user in Firebase. Does not update automatically.
  /// Use [FirebaseAuth.authStateChanges] to listen to the state changes.
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  models.User? currentUser;
  models.ApiSettings? apiSettings;

  /// Singleton instance
  static final FirebaseCore instance = FirebaseCore._privateConstructor();

  /// Gets proper [FirebaseFirestore] instance
  FirebaseFirestore getFirebaseFirestore() {
    return config.firebaseAppName != null ? FirebaseFirestore.instanceFor(app: Firebase.app(config.firebaseAppName!),) : FirebaseFirestore.instance;
  }

  /// Config to set custom names for rooms and users collections. Also
  /// see [FirebaseCoreConfig].
  FirebaseCoreConfig config = const FirebaseCoreConfig(firebaseAppName: null, usersCollectionName: "users", accountCollectionName: "accounts", apiSettingCollectionName: "apiSettings", appSettingCollectionName: "appSettings", transactionCollectionName: "transactions");

  FirebaseCore._privateConstructor() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      firebaseUser = user;
    });
  }

  /// Sets custom config to change default names for rooms
  /// and users collections. Also see [FirebaseCoreConfig].
  void setConfig(FirebaseCoreConfig firebaseChatCoreConfig) {
    config = firebaseChatCoreConfig;
  }

  Future<void> ensureInitialized()async{
    currentUser ??= await getUser(userId: firebaseUser!.uid);
    apiSettings ??= await getApiSetting();
    debugPrint("FirebaseCore ensureInitialized...");
  }

  void authCheck(){
    if(firebaseUser==null)throw Exception("Your are not login");
  }

  /// Verify user phone number with firebase
  /// Return [String] representing verification's id
  Future<void> verifyPhoneNumber({required String phoneNumber, Function(String verificationId)? codeAutoRetrievalTimeout, required Function(String id, int? resendToken) codeSent, Function(FirebaseAuthException e)? verificationFailed,}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        debugPrint("verificationCompleted");
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint(e.code);
        verificationFailed?.call(e);
      },
      codeSent: (String id, int? resendToken) async {
        codeSent.call(id, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId){
        codeAutoRetrievalTimeout?.call(verificationId);
      },
    ).onError((error, stackTrace){
      verificationFailed?.call(FirebaseAuthException(code: error.toString()));
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      return null;
    });
  }

  Future<bool> sendCodeToFirebase({required String code, required String verificationId, bool updatePhoneNumber = false}) async {
    bool success = false;
    var credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);

    Future<void> l(){
      if(updatePhoneNumber){
        return (FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential))!;
      }
      return FirebaseAuth.instance.signInWithCredential(credential);
    }
    await l().then((value) {}).whenComplete(() async {
      if(FirebaseAuth.instance.currentUser!=null){
        success = true;
      }
    }).onError((error, stackTrace) {
      success = false;
    });
    return success;
  }

  Future<void> createUserInFirestore({required String name, UserRole role = UserRole.user, required String phoneNumber, bool isActive = true, Map<String, dynamic> metadata = const {},}) async {
    authCheck();

    await getFirebaseFirestore().collection(config.usersCollectionName).doc(firebaseUser!.uid).set({
      'createdAt': FieldValue.serverTimestamp(),
      'name': name,
      'metadata': metadata,
      'role': role.name,
      'updatedAt': FieldValue.serverTimestamp(),
      'phoneNumber': phoneNumber,
      'isActive': isActive,
    });
  }

  ///Update transaction
  Future<void> updateUser(models.User user)async {
    authCheck();
    var userMap = user.toMap();
    userMap.removeWhere((key, value) => key=="createdAt" || key=="id");
    userMap['updatedAt'] = FieldValue.serverTimestamp();

    await getFirebaseFirestore().collection(config.usersCollectionName).doc(user.id).update(userMap);
  }

  Future<bool> hasUserWithPhoneNumber(String phoneNumber)async{
    models.User? user = await getUserByPhoneNumber(phoneNumber: phoneNumber);
    return user!=null;
  }

  Future<models.User> getUser({required String userId})async{
    authCheck();
    final doc = await getFirebaseFirestore().collection(config.usersCollectionName).doc(userId).get();
    if(!doc.exists)throw Exception("User not found!");
    return models.User.fromMap(processSimpleDocument(doc));
  }

  Future<models.User?> getUserByPhoneNumber({required String phoneNumber}) async {
    final res = await getFirebaseFirestore().collection(config.usersCollectionName).where("phoneNumber", isEqualTo: phoneNumber).limit(1).get();
    if (res.docs.isEmpty) return null;
    final data = processSimpleDocument(res.docs.first);
    
    return models.User.fromMap(data);
  }

  ///Create transaction in firebase
  Future<String> createTransaction({required models.Account account, required double amount, required models.TransactionType type, String? payeeNote,String? payerMessage, Map<String, dynamic> metadata = const {}}) async {
    authCheck();

    assert(apiSettings!=null);
    var client = Collection(baseUrl: apiSettings!.baseUrl, targetEnvironment: apiSettings!.environment, currency: apiSettings!.currency, collectionPrimaryKey: apiSettings?.collectionPrimaryKey, collectionUserId: apiSettings?.collectionUserId, collectionApiSecret: apiSettings?.collectionApiSecret, callbackUrl: apiSettings!.callbackHost);

    var doc = getFirebaseFirestore().collection(config.transactionCollectionName).doc();

    var params = {'mobile': currentUser?.phoneNumber.substring("+229".length), 'payee_note' : payeeNote??"Dépôt Momo Epargne sur votre compte : ${account.name}", 'payer_message' : payerMessage??account.description, 'external_id' : doc.id, 'currency' : apiSettings?.currency, 'amount' : amount};

    var uuid = await client.requestToPay(params: params);
    var t = await client.getTransaction(transactionId: uuid);

    metadata.addAll({"additionalInfo":t.toMap()});

    await getFirebaseFirestore().collection(config.transactionCollectionName).doc(doc.id).set({
      'userId': firebaseUser?.uid,
      'uuid': uuid,
      'accountId': account.id,
      'amount': amount,
      'status': models.TransactionStatus.pending,
      'type': type.name,
      'currency': apiSettings?.currency,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'metadata': metadata,
    });

    return doc.id;
  }

  ///Update transaction
  Future<void> updateTransaction(models.Transaction transaction)async {
    authCheck();
    var transactionMap = transaction.toMap();
    transactionMap.removeWhere((key, value) => key=="createdAt" || key=="id" || key=="userId");
    transactionMap['updatedAt'] = FieldValue.serverTimestamp();

    await getFirebaseFirestore().collection(config.transactionCollectionName).doc(transaction.id).update(transactionMap);
  }

  ///Get one transaction
  Future<models.Transaction> getTransaction(String id) async {
    authCheck();
    var doc = await getFirebaseFirestore().collection(config.transactionCollectionName).doc(id).get();
    final transaction =  models.Transaction.fromMap(processSimpleDocument(doc));
    return transaction;
  }

  ///Get current user transactions
  Query getTransactionsQuery() {
    authCheck();
    return getFirebaseFirestore().collection(config.transactionCollectionName).where("userId", isEqualTo: firebaseUser?.uid);
  }

  /// Create Saving Account
  Future<String> createAccount({required String name, required String description, required DateTime withdrawalDate,Map<String, dynamic> metadata = const {}})async {
    authCheck();
    var doc = getFirebaseFirestore().collection(config.accountCollectionName).doc();
    await getFirebaseFirestore().collection(config.accountCollectionName).doc(doc.id).set({
      'userId': firebaseUser?.uid,
      'name': name,
      'description': description,
      'withdrawalDate': Timestamp.fromDate(withdrawalDate),
      'balance': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt':FieldValue.serverTimestamp(),
      'metadata': metadata,
    });
    return doc.id;
  }

  ///Update transaction
  Future<void> updateAccount(models.Account account)async {
    authCheck();
    var accountMap = account.toMap();
    accountMap.removeWhere((key, value) => key=="createdAt" || key=="withdrawalDate" || key=="userId" || key=="id");
    accountMap['updatedAt'] = FieldValue.serverTimestamp();

    await getFirebaseFirestore().collection(config.transactionCollectionName).doc(account.id).update(accountMap);
  }

  /// Get current user accounts
  Query getAccountsQuery(){
    authCheck();
    return getFirebaseFirestore().collection(config.accountCollectionName).where("userId", isEqualTo: firebaseUser?.uid);
  }

  ///Get one transaction
  Future<models.Account> getAccount(String id) async {
    authCheck();
    var doc = await getFirebaseFirestore().collection(config.accountCollectionName).doc(id).get();
    var map = processSimpleDocument(doc);
    map["withdrawalDate"] = map["withdrawalDate"]?.millisecondsSinceEpoch;
    final account = models.Account.fromMap(map);
    return account;
  }

  ///Create apiSettings
  Future<void> createApiSettings(models.ApiSettings apiSettings)async {
    authCheck();
    var apiSettingsMap = apiSettings.toMap();
    apiSettingsMap.removeWhere((key, value) => key=="id");
    apiSettingsMap["createdAt"] = FieldValue.serverTimestamp();
    apiSettingsMap["updatedAt"] = FieldValue.serverTimestamp();

    await getFirebaseFirestore().collection(config.apiSettingCollectionName).add(apiSettingsMap);
  }

  ///Update transaction
  Future<void> updateApiSettings(models.ApiSettings apiSettings)async {
    authCheck();
    var apiSettingsMap = apiSettings.toMap();
    apiSettingsMap.removeWhere((key, value) => key=="createdAt" || key=="id");
    apiSettingsMap['updatedAt'] = FieldValue.serverTimestamp();

    await getFirebaseFirestore().collection(config.apiSettingCollectionName).doc(apiSettings.id).update(apiSettingsMap);
  }

  ///Get ApiSettings
  Future<models.ApiSettings> getApiSetting() async {
    authCheck();
    var query = await getFirebaseFirestore().collection(config.apiSettingCollectionName).limit(1).get();
    if(query.docs.isEmpty)throw Exception("No Found");

    models.ApiSettings apiSettings = models.ApiSettings.fromMap(processSimpleDocument(query.docs.first));

    bool processUpdate = false;
    if(apiSettings.collectionUserId.isEmpty){
      var c = Collection(baseUrl: apiSettings.baseUrl, targetEnvironment: apiSettings.environment, currency: apiSettings.currency, collectionPrimaryKey: apiSettings.collectionPrimaryKey, collectionUserId: apiSettings.collectionUserId, collectionApiSecret: apiSettings.collectionApiSecret, callbackUrl: apiSettings.callbackHost);
      var u = await c.createUser();
      apiSettings = apiSettings.copyWith(collectionUserId: u.uuid, collectionApiSecret: u.apiKey);
      processUpdate = true;
    }

    if(apiSettings.disbursementUserId.isEmpty){
      var c = Disbursement(baseUrl: apiSettings.baseUrl, targetEnvironment: apiSettings.environment, currency: apiSettings.currency, disbursementPrimaryKey: apiSettings.disbursementPrimaryKey, disbursementUserId: apiSettings.disbursementUserId, disbursementApiSecret: apiSettings.disbursementApiSecret, callbackUrl: apiSettings.callbackHost);
      var u = await c.createUser();
      apiSettings = apiSettings.copyWith(disbursementUserId: u.uuid, disbursementApiSecret: u.apiKey);
      processUpdate = true;
    }
    if(processUpdate)updateApiSettings(apiSettings);

    return apiSettings;
  }

  ///Create Api user


}