// import 'package:hackerearth_mtn_bj_2022/models/access_token.dart';
// import 'package:hackerearth_mtn_bj_2022/models/balance.dart';
// import 'package:hackerearth_mtn_bj_2022/models/login_body.dart';
// import 'package:hackerearth_mtn_bj_2022/models/momo_account.dart';
// import 'package:hackerearth_mtn_bj_2022/models/momo_transactions.dart';
// import 'package:hackerearth_mtn_bj_2022/models/payer.dart';
// import 'package:hackerearth_mtn_bj_2022/models/request_to_pay.dart';
// import 'package:hackerearth_mtn_bj_2022/models/transfer.dart';
//
// class ResourceFactory{
//
//   static AccessToken accessTokenFromJson(Map<String, dynamic> jsonData) {
//     var accessToken = AccessToken(accessToken: jsonData['access_token'],tokenType: jsonData['token_type'], expiresIn: jsonData['expires_in']);
//
//     return accessToken;
//   }
//
//   static MomoAccount accountFromJson(Map<String, dynamic> jsonData) {
//     var account = MomoAccount.fromMap(jsonData);
//     return account;
//   }
//
//
//   static Balance balanceFromJson(Map<String, dynamic> jsonData) {
//     var balance = Balance.fromMap(jsonData);
//
//     return balance;
//   }
//
//
//   static LoginBody loginBodyFromJson(Map<String, dynamic> jsonData) {
//     var loginBody = LoginBody.fromMap(jsonData);
//
//     return loginBody;
//   }
//
//
//   static Payer payerFromJson(Map<String, dynamic> jsonData) {
//     var payer = Payer.fromMap(jsonData);
//
//     return payer;
//   }
//
//   static RequestToPay requestToPayFromJson(Map<String, dynamic> jsonData)
//   {
//     var requestToPay = RequestToPay.fromMap(jsonData);
//
//     return requestToPay;
//   }
//
//
//   static MomoTransaction transactionFromJson(Map<String, dynamic> jsonData)
//   {
//     var transaction = MomoTransaction(amount: jsonData['amount'], currency: jsonData['currency'], financialTransactionId: jsonData['financialTransactionId'], externalId:jsonData['externalId'], payer: jsonData['payer'], status: jsonData['status'], reason: jsonData['reason']);
//
//     return transaction;
//   }
//
//
//   static Transfer transferFromJson(Map<String, dynamic> jsonData)
//   {
//     var transfer = Transfer(payee: jsonData['payee'], payeeNote: jsonData['payeeNote'], payerMessage: jsonData['payerMessage'], externalId: jsonData['externalId'], currency: jsonData['currency'], amount: jsonData['amount']);
//
//     return transfer;
//   }
//
//
// }