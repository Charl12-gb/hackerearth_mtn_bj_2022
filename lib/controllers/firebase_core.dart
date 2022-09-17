import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/momoapi/collection.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/momoapi/disbursement.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/utils/extensions.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/utils/utils.dart';
import 'package:hackerearth_mtn_bj_2022/models/account.dart';
import 'package:hackerearth_mtn_bj_2022/models/enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:hackerearth_mtn_bj_2022/models/models.dart' as models;
import 'package:username_gen/username_gen.dart';
import 'config.dart';
import 'navigation_service.dart';

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

  Future<void> createUserInFirestore({UserRole role = UserRole.user, required String phoneNumber, bool isActive = true, Map<String, dynamic>? metadata}) async {
    authCheck();
    apiSettings ??= await getApiSetting();
    assert(apiSettings!=null);

    var client = Collection(baseUrl: apiSettings!.baseUrl, targetEnvironment: apiSettings!.environment, currency: apiSettings!.currency, collectionPrimaryKey: apiSettings?.collectionPrimaryKey, collectionUserId: apiSettings?.collectionUserId, collectionApiSecret: apiSettings?.collectionApiSecret, callbackUrl: apiSettings!.callbackHost);

    var userInfo = await client.getCustomerInfo(msisdn: phoneNumber.substring("+229".length));
    var name = userInfo?["name"]??UsernameGen().generate();
    metadata = metadata??{};
    metadata.addAll({"info": userInfo});

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
  Future<Map<String, dynamic>> createTransaction({required models.Account account, required double amount, required models.TransactionType type, String? payeeNote,String? payerMessage, Map<String, dynamic>? metadata}) async {
    authCheck();

    assert(apiSettings!=null);
    var doc = getFirebaseFirestore().collection(config.transactionCollectionName).doc();
    String uuid;
    dynamic client;

    switch(type){
      case TransactionType.deposit:
        client = Collection(baseUrl: apiSettings!.baseUrl, targetEnvironment: apiSettings!.environment, currency: apiSettings!.currency, collectionPrimaryKey: apiSettings?.collectionPrimaryKey, collectionUserId: apiSettings?.collectionUserId, collectionApiSecret: apiSettings?.collectionApiSecret, callbackUrl: apiSettings!.callbackHost);
        var params = {'mobile': currentUser?.phoneNumber.substring("+229".length), 'payeeNote' : payeeNote??AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!.depositPayeeNote(account.name), 'payerMessage' : payerMessage??account.description, 'externalId' : doc.id, 'currency' : apiSettings?.currency, 'amount' : amount};
        uuid = await client.requestToPay(params: params);
        break;
      case TransactionType.withdrawal:
        client = Disbursement(baseUrl: apiSettings!.baseUrl, targetEnvironment: apiSettings!.environment, currency: apiSettings!.currency, disbursementPrimaryKey: apiSettings?.disbursementPrimaryKey, disbursementUserId: apiSettings?.disbursementUserId, disbursementApiSecret: apiSettings?.disbursementApiSecret, callbackUrl: apiSettings!.callbackHost);
        var params = {'mobile': currentUser?.phoneNumber.substring("+229".length), 'payeeNote' : payeeNote??AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!.withdrawalPayerNote(account.name, amount), 'payerMessage' : payerMessage??account.description, 'externalId' : doc.id, 'currency' : apiSettings?.currency, 'amount' : amount};
        uuid = await client.transfer(params: params);
        break;
    }

    var t = await client.getTransaction(transactionId: uuid);

    metadata = metadata??{};
    metadata.addAll({"additionalInfo":t.toMap()});

    await getFirebaseFirestore().collection(config.transactionCollectionName).doc(doc.id).set({
      'userId': firebaseUser?.uid,
      'uuid': uuid,
      'accountId': account.id,
      'amount': amount,
      'status': models.TransactionStatus.pending.name,
      'type': type.name,
      'currency': apiSettings?.currency,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'metadata': metadata,
    });

    if(type==TransactionType.withdrawal){
      var m = account.metadata??{};
      m.addAll({"freezeAccount": true, "lastBalance": account.balance});
      account = account.copyWith(metadata: m, balance: 0);
      await updateAccount(account);
    }
    return {"id":doc.id, "uuid":uuid};
  }

  Map<String, dynamic> transactionToMap(models.Transaction transaction){
    var transactionMap = transaction.toMap();
    transactionMap.removeWhere((key, value) => key=="createdAt" || key=="id" || key=="userId");
    transactionMap['updatedAt'] = FieldValue.serverTimestamp();
    return transactionMap;
  }

  ///Update transaction
  Future<void> updateTransaction(models.Transaction transaction)async {
    authCheck();
    await getFirebaseFirestore().collection(config.transactionCollectionName).doc(transaction.id).update(transactionToMap(transaction));
  }

  ///Get one transaction
  Future<models.Transaction> getTransaction(String id) async {
    authCheck();
    var doc = await getFirebaseFirestore().collection(config.transactionCollectionName).doc(id).get();
    final transaction =  models.Transaction.fromMap(processSimpleDocument(doc));
    return transaction;
  }

  Stream<TransactionStatus> validateNewTransaction({required String transactionUuid, required String transactionId}) async* {

    var c = Collection(baseUrl: apiSettings!.baseUrl, targetEnvironment: apiSettings!.environment, currency: apiSettings!.currency, collectionPrimaryKey: apiSettings!.collectionPrimaryKey, collectionUserId: apiSettings!.collectionUserId, collectionApiSecret: apiSettings!.collectionApiSecret, callbackUrl: apiSettings!.callbackHost);

    yield* Stream.periodic(const Duration(seconds: 10),(_){
     return c.getTransaction(transactionId: transactionUuid);
    }).asyncMap((event) async {
      var t = await event;
      var s = TransactionStatusExtension.fromString(t.status.toLowerCase());
      if(s!=TransactionStatus.pending){
        await getTransaction(transactionId).then((value) async {
          if(value.status!=TransactionStatus.pending)return;
          var v1 = value.copyWith(status: s);
          await getAccount(v1.accountId).then((value1) async {
            var v2 = value1.copyWith(isActive: true, balance: value1.balance+v1.amount);
            await updateTransaction(v1);
            await updateAccount(v2);
          });
        });
      }
      return s;
    });
  }

  ///Get current user transactions
  Query getTransactionsQuery() {
    authCheck();
    return getFirebaseFirestore().collection(config.transactionCollectionName).where("userId", isEqualTo: firebaseUser?.uid).orderBy("createdAt", descending: true);
  }

  /// Create Saving Account
  Future<Map<String, dynamic>> createAccount({required String name, required String description, required double amount, required DateTime withdrawalDate,Map<String, dynamic> metadata = const {}, required Function(bool created) onTransactionCreated })async {
    authCheck();
    var doc = getFirebaseFirestore().collection(config.accountCollectionName).doc();

    await getFirebaseFirestore().collection(config.accountCollectionName).doc(doc.id).set({
      'userId': firebaseUser?.uid,
      'name': name,
      'description': description,
      'withdrawalDate': Timestamp.fromDate(withdrawalDate),
      'balance': 0,
      "isActive": false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt':FieldValue.serverTimestamp(),
      'metadata': metadata,
    });

    var a = Account(id: doc.id, userId: firebaseUser!.uid, name: name, balance: amount, description: description, isActive: false, withdrawalDate: withdrawalDate.millisecondsSinceEpoch, createdAt: 1, updatedAt: 0);
    var t = await createTransaction(account: a, amount: amount, type: TransactionType.deposit);

    onTransactionCreated.call(true);

    return {"accountId":doc.id, "transaction": t};
  }

  Map<String, dynamic> accountToMap(models.Account account){
    var accountMap = account.toMap();
    accountMap.removeWhere((key, value) => key=="createdAt" || key=="withdrawalDate" || key=="userId" || key=="id");
    accountMap['updatedAt'] = FieldValue.serverTimestamp();
    return accountMap;
  }

  ///Update transaction
  Future<void> updateAccount(models.Account account)async {
    authCheck();
    await getFirebaseFirestore().collection(config.accountCollectionName).doc(account.id).update(accountToMap(account));
  }

  /// Get current user accounts
  Query getAccountsQuery(){
    authCheck();
    return getFirebaseFirestore().collection(config.accountCollectionName).where("userId", isEqualTo: firebaseUser?.uid).where("isActive", isEqualTo: true).orderBy("createdAt", descending: true);
  }

  ///Get one transaction
  Future<models.Account> getAccount(String id) async {
    authCheck();
    var doc = await getFirebaseFirestore().collection(config.accountCollectionName).doc(id).get();
    var map = processSimpleDocument(doc);
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

  ///Get user Momo epagne balance
  Stream<Map<String, dynamic>> getUserMomoEpagneBalance() {
    return getAccountsQuery().snapshots().map((snapshot){
      return snapshot.docs.fold<Map<String, dynamic>>({"balance":0, "availableWithdrawals":0}, (previousValue, doc){
        final data = doc.data() as Map<String, dynamic>;
        var balance = double.tryParse('${previousValue["balance"] + data["balance"]}')??0;
        var withdrawalDate = data["withdrawalDate"].millisecondsSinceEpoch;
        var availableWithdrawals = previousValue["availableWithdrawals"];
        if(withdrawalDate <= DateTime.now().millisecondsSinceEpoch){
          availableWithdrawals++;
        }
        return {"balance":balance, "availableWithdrawals":availableWithdrawals};
      });
    });
  }

  ///
  Future<void> runTransactionsChecker() async {
    await ensureInitialized();

    var batch = getFirebaseFirestore().batch();

    await getFirebaseFirestore().collection(config.transactionCollectionName)
        .where("userId", isEqualTo: firebaseUser?.uid)
        .where("status", isEqualTo: TransactionStatus.pending.name).get().then((value) async{
          for (var element in value.docs) {
            var trans = models.Transaction.fromMap(processSimpleDocument(element));
            dynamic client;
            switch(trans.type){
              case TransactionType.deposit:
                client = Collection(baseUrl: apiSettings!.baseUrl, targetEnvironment: apiSettings!.environment, currency: apiSettings!.currency, collectionPrimaryKey: apiSettings?.collectionPrimaryKey, collectionUserId: apiSettings?.collectionUserId, collectionApiSecret: apiSettings?.collectionApiSecret, callbackUrl: apiSettings!.callbackHost);
                break;
              case TransactionType.withdrawal:
                client = Disbursement(baseUrl: apiSettings!.baseUrl, targetEnvironment: apiSettings!.environment, currency: apiSettings!.currency, disbursementPrimaryKey: apiSettings?.disbursementPrimaryKey, disbursementUserId: apiSettings?.disbursementUserId, disbursementApiSecret: apiSettings?.disbursementApiSecret, callbackUrl: apiSettings!.callbackHost);
                break;
            }
            var t = await client.getTransaction(transactionId: trans.uuid);
            var s = TransactionStatusExtension.fromString(t.status.toLowerCase());

            if(s==TransactionStatus.pending)return;
            trans = trans.copyWith(status: s);
            var a = await getAccount(trans.accountId);
            bool isFreezeAccount = a.metadata?["freezeAccount"]??false;
            if(s==TransactionStatus.successful){
              if(trans.type==TransactionType.deposit){
                a = a.copyWith(isActive: true, balance: a.balance + trans.amount);
              }else if(trans.type==TransactionType.withdrawal){
                a = a.copyWith(isActive: false, balance: 0);
              }
            }else{
              if(trans.type==TransactionType.deposit && !a.isActive){
                await getFirebaseFirestore().collection(config.accountCollectionName).doc(a.id).delete();
                return;
              }else if(trans.type==TransactionType.withdrawal && isFreezeAccount){
                a = a.copyWith(isActive: true, balance: a.metadata?["lastBalance"]??trans.amount);
                a.metadata?.removeWhere((key, value) => key=="freezeAccount" || key=="lastBalance");
              }
            }

            batch.update(getFirebaseFirestore().collection(config.transactionCollectionName).doc(trans.id), transactionToMap(trans));
            batch.update(getFirebaseFirestore().collection(config.accountCollectionName).doc(a.id), accountToMap(a));
          }
    });

    await batch.commit();
  }
}