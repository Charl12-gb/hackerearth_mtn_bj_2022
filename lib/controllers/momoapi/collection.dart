import 'dart:convert';

import 'package:hackerearth_mtn_bj_2022/models/models.dart';
import 'package:uuid/uuid.dart';
import 'api_request.dart';
import 'error/momo_api_error.dart';

class Collection extends ApiRequest{
  Collection({required super.baseUrl, required super.targetEnvironment, required super.currency, required super.collectionPrimaryKey, required super.collectionUserId, required super.collectionApiSecret, required super.callbackUrl}) : super(disbursementApiSecret: '',disbursementPrimaryKey: '', disbursementUserId: '',remittanceApiSecret: '',remittancePrimaryKey: '',remittanceUserId: '');

  Future<AccessToken> getToken() async {
    var url = '$baseUrl/collection/token/';

    var encodedString = base64Encode(utf8.encode("$collectionUserId:$collectionApiSecret"));

    var headers = {
      'Authorization': 'Basic $encodedString',
      'Content-Type': 'application/json',
      'Ocp-Apim-Subscription-Key': collectionPrimaryKey
    };

    var response = await request(method: Http.post, url: url, headers: headers);
    var obj = AccessToken.fromMap(response.data);

    return obj;
  }

  Future<Balance> getBalance({Map<String, dynamic>? queryParameters, $options}) async {
    var url = "$baseUrl/collection/v1_0/account/balance";
    var token = await getToken();

    var headers = {
      'Authorization': 'Bearer ${token.getToken()}',
      'Content-Type': 'application/json',
      "X-Target-Environment": targetEnvironment,
      'Ocp-Apim-Subscription-Key': collectionPrimaryKey
    };

    var response = await request(method: Http.get, url: url, headers: headers, queryParameters: queryParameters);
    var obj = Balance.fromMap(response.data);

    return obj;
  }

  Future<MomoTransaction> getTransaction({required transactionId, Map<String, dynamic>? queryParameters}) async {
    var url = "$baseUrl/collection/v1_0/requesttopay/$transactionId";

    var token = await getToken();

    var headers = {
      'Authorization': 'Bearer ${token.getToken()}',
      'Content-Type': 'application/json',
      "X-Target-Environment": targetEnvironment,
      'Ocp-Apim-Subscription-Key': collectionPrimaryKey,
    };

    var response = await request(method: Http.get, url: url, headers: headers, queryParameters: queryParameters);

    var obj = MomoTransaction.fromMap(response.data);

    return obj;
  }

  Future<String> requestToPay({required Map<String, dynamic> params, options}) async {
    _validateParams(params: params);

    var url = "$baseUrl/collection/v1_0/requesttopay";

    var token = await getToken();

    var uuid = const Uuid().v4();

    var headers = {
      'Authorization': 'Bearer ${token.getToken()}',
      "X-Target-Environment" : targetEnvironment,
      'Ocp-Apim-Subscription-Key' : collectionPrimaryKey,
      "X-Reference-Id" : uuid
    };

    var data = {
      "payer": {
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

  Future<ApiUser> createUser()async{
    var url = "$baseUrl/v1_0/apiuser";
    var uuid = const Uuid().v4();

    var headers = {
      "Ocp-Apim-Subscription-Key" : collectionPrimaryKey,
      "X-Reference-Id" : uuid,
    };

    var data = {
      "providerCallbackHost": callbackUrl
    };

    var response = await request(method: Http.post, url: url, headers: headers, body: data);
    collectionUserId = uuid;
    var apikey = await createApikey();
    collectionApiSecret = apikey;
    return ApiUser(uuid: uuid, apiKey: apikey);
  }

  Future<Map<String, dynamic>?> getCustomerInfo({required String msisdn})async{
    var url = "$baseUrl/collection/v1_0/accountholder/msisdn/$msisdn/basicuserinfo";

    var token = await getToken();

    var headers = {
      "Authorization": "Bearer ${token.getToken()}",
      "Ocp-Apim-Subscription-Key" : collectionPrimaryKey,
      "X-Reference-Id": collectionUserId,
      "X-Target-Environment": targetEnvironment,
    };

    var response = await request(method: Http.get, url: url, headers: headers);

    if(response.data==null){
      throw MomoApiError(message: "User not found");
    }

    return response.data;
  }

  Future<String> createApikey() async {
    var url = "$baseUrl/v1_0/apiuser/$collectionUserId/apikey";
    var headers = {
      "Ocp-Apim-Subscription-Key" : collectionPrimaryKey,
    };
    var response = await request(method: Http.post, url: url, headers: headers);
    return response.data["apiKey"];
  }

  isActive({required mobile, params = const []}) async {
    var token = getToken();

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      "X-Target-Environment": targetEnvironment,
      'Ocp-Apim-Subscription-Key': collectionPrimaryKey,
    };

    var url = "$baseUrl/collection/v1_0/accountholder/MSISDN/mobile/active}";

    var response = await request(method: Http.get, url: url, headers: headers);

    return response;
  }

  _validateParams({params}) {
    if (params == null && !(params.runtimeType==List)) {
      var message = "You must pass an array as the first argument to MomoApi API method calls.  (HINT: an example call to create a charge would be: \"MomoApi\\Charge::create(['amount' => 100, 'currency' => 'usd', 'source' => 'tok_1234'])\")";
      throw MomoApiError(message: message);
    }
  }

}
