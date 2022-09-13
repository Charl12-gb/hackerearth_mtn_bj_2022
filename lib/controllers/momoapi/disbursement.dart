import 'dart:convert';

import 'package:hackerearth_mtn_bj_2022/models/models.dart';
import 'package:uuid/uuid.dart';
import 'api_request.dart';
import 'error/momo_api_error.dart';

class Disbursement extends ApiRequest{
  Disbursement({required super.baseUrl, required super.targetEnvironment, required super.currency, required super.disbursementPrimaryKey, required super.disbursementUserId, required super.disbursementApiSecret}) : super(collectionApiSecret: '',collectionPrimaryKey: '', collectionUserId: '',remittanceApiSecret: '',remittancePrimaryKey: '',remittanceUserId: '');

  Future<AccessToken> getToken() async {
    var url = '$baseUrl/disbursement/token/';

    var encodedString = base64Encode(utf8.encode("$disbursementUserId:$disbursementApiSecret"));

    var headers = {
      'Authorization': 'Basic $encodedString',
      'Content-Type': 'application/json',
      'Ocp-Apim-Subscription-Key': disbursementPrimaryKey
    };

    var response = await request(method: Http.post, url: url, headers: headers);
    var obj = AccessToken.fromMap(response.data);

    return obj;
  }

  Future<Balance> getBalance({Map<String, dynamic>? queryParameters, $options}) async {
    var url = "$baseUrl/disbursement/v1_0/account/balance";
    var token = await getToken();

    var headers = {
      'Authorization': 'Bearer ${token.getToken()}',
      'Content-Type': 'application/json',
      "X-Target-Environment": targetEnvironment,
      'Ocp-Apim-Subscription-Key': disbursementPrimaryKey
    };

    var response = await request(method: Http.get, url: url, headers: headers, queryParameters: queryParameters);
    var obj = Balance.fromMap(response.data);

    return obj;
  }

  Future<Transfer> getTransaction({required transactionId, Map<String, dynamic>? queryParameters}) async {
    var url = "$baseUrl/disbursement/v1_0/transfer/$transactionId";

    var token = await getToken();

    var headers = {
      'Authorization': 'Bearer ${token.getToken()}',
      'Content-Type': 'application/json',
      "X-Target-Environment": targetEnvironment,
      'Ocp-Apim-Subscription-Key': disbursementPrimaryKey,
    };

    var response = await request(method: Http.get, url: url, headers: headers, queryParameters: queryParameters);
    var obj = Transfer.fromMap(response.data);

    return obj;
  }

  Future<String> transfer({required Map<String, dynamic> params, options}) async {
    _validateParams(params: params);

    var url = "$baseUrl/disbursement/v1_0/transfer";

    var token = await getToken();

    var uuid = const Uuid().v4();

    var headers = {
      'Authorization': 'Bearer ${token.getToken()}',
      'Content-Type' : 'application/json',
      "X-Target-Environment" : targetEnvironment,
      'Ocp-Apim-Subscription-Key' : disbursementPrimaryKey,
      "X-Reference-Id" : uuid
    };

    var data = {
      "payee": {
        "partyIdType": "MSISDN",
        "partyId": params['mobile']
      },
      "payeeNote": params['payeeNote'],
      "payerMessage": params['payerMessage'],
      "externalId": params['externalId'],
      "currency": params['currency'],
      "amount": params['amount']
    };

    var response = await request(method: Http.post, url: url, headers: headers, body: data);

    return uuid;
  }

  isActive({required mobile, params = const []}) async {
    var token = await getToken();

    var headers = {
      'Authorization': 'Bearer ${token.getToken()}',
      'Content-Type': 'application/json',
      "X-Target-Environment": targetEnvironment,
      'Ocp-Apim-Subscription-Key': disbursementPrimaryKey,
    };

    var url = "$baseUrl/disbursement/v1_0/accountholder/MSISDN/$mobile/active}";

    var response = await request(method: Http.get, url: url, headers: headers);

    return response;
  }

  /// @param array|null|mixed $params The list of parameters to validate
  /// @throws \MomoApi\Error\MomoApiError if $params exists and is not an array
  _validateParams({params}) {
    if (params && !(params.runtimeType==List)) {
      var message = "You must pass an array as the first argument to MomoApi API method calls.  (HINT: an example call to create a charge would be: \"MomoApi\\Charge::create(['amount' => 100, 'currency' => 'usd', 'source' => 'tok_1234'])\")";
      throw MomoApiError(message: message);
    }
  }
}