import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hackerearth_mtn_bj_2022/controllers/firebase_core.dart';
import 'package:hackerearth_mtn_bj_2022/models/models.dart';

import 'error/authentication.dart';
import 'error/idempotency.dart';
import 'error/invalid_request.dart';
import 'error/momo_api_error.dart';
import 'error/rate_limit.dart';

class ApiRequest {
  String baseUrl;
  String targetEnvironment;
  String currency;
  String callbackUrl;
  String? collectionPrimaryKey;
  String? collectionUserId;
  String? collectionApiSecret;
  String? remittanceUserId;
  String? remittanceApiSecret;
  String? remittancePrimaryKey;
  String? disbursementUserId;
  String? disbursementApiSecret;
  String? disbursementPrimaryKey;

  static late Dio _httpClient;

  static get httpClient => _httpClient;

  @protected static set httpClient(value) {
    _httpClient = value;
  }

  @protected Future<Response> request({required Http method, required String url, Map<String, dynamic>? body,Map<String, dynamic>? queryParameters, Map<String, dynamic> headers = const {}}) async {
    _httpClient = Dio(BaseOptions(headers: headers, contentType: "application/json"));
    Response response;
      try{
        switch(method){
          case Http.post:
            response = await _httpClient.post(url, queryParameters: queryParameters, data: jsonEncode(body));
            break;
          case Http.get:
            response = await _httpClient.get(url, queryParameters: queryParameters);
            break;
          case Http.put:
            response = await _httpClient.put(url, queryParameters: queryParameters, data: jsonEncode(body));
            break;
          case Http.delete:
            response = await _httpClient.delete(url, queryParameters: queryParameters, data: jsonEncode(body));
            break;
        }
        return response;
      }on DioError catch (_){
        if(_.response?.statusCode==401){
          FirebaseCore.instance.getApiSetting(forceRenew: true);
        }
        debugPrint(_.response?.data.toString());
        debugPrint(_.response?.realUri.toString());
        throw Exception(_.toString());
      }
  }

  handleErrorResponse({rbody, rcode, rheaders, resp, errorData}) {
    var msg = errorData['message'];
    var param = errorData['param'];
    var code = errorData['code'];
    var type = errorData['type'];

    switch (rcode) {
      case 400:
        // 'rate_limit' code is deprecated, but left here for backwards compatibility
        // for API versions earlier than 2015-09-08
        if (code == 'rate_limit') {
          return RateLimit(message: msg, httpBody: param, httpHeaders: rheaders, httpStatus: rcode, jsonBody: rbody,);
        }
        if (type == 'idempotency_error') {
          return Idempotency(message: msg, httpBody: param, httpHeaders: rheaders, httpStatus: rcode, jsonBody: rbody,);
        }
        return InvalidRequest(message: msg, httpBody: param, httpHeaders: rheaders, httpStatus: rcode, jsonBody: rbody,);
      case 404:
        return InvalidRequest(message: msg, httpBody: param, httpHeaders: rheaders, httpStatus: rcode, jsonBody: rbody,);
      case 401:
        return Authentication(message: msg, httpBody: param, httpHeaders: rheaders, httpStatus: rcode, jsonBody: rbody,);
      default:
        return MomoApiError(message: msg, httpBody: param, httpHeaders: rheaders, httpStatus: rcode, jsonBody: '');
    }
  }

  ApiRequest({
    required this.baseUrl,
    required this.targetEnvironment,
    required this.currency,
    required this.callbackUrl,
    this.collectionPrimaryKey,
    this.collectionUserId,
    this.collectionApiSecret,
    this.remittanceUserId,
    this.remittanceApiSecret,
    this.remittancePrimaryKey,
    this.disbursementUserId,
    this.disbursementApiSecret,
    this.disbursementPrimaryKey,
  });
}
