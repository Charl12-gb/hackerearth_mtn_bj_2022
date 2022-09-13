import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hackerearth_mtn_bj_2022/models/models.dart';

import 'error/authentication.dart';
import 'error/idempotency.dart';
import 'error/invalid_request.dart';
import 'error/momo_api_error.dart';
import 'error/rate_limit.dart';

class ApiRequest {
  final String _baseUrl;
  final String _targetEnvironment;
  final String _currency;
  final String? _collectionPrimaryKey;
  final String? _collectionUserId;
  final String? _collectionApiSecret;
  final String? _remittanceUserId;
  final String? _remittanceApiSecret;
  final String? _remittancePrimaryKey;
  final String? _disbursementUserId;
  final String? _disbursementApiSecret;
  final String? _disbursementPrimaryKey;

  static late Dio _httpClient;

  const ApiRequest({
    required String baseUrl,
    required String targetEnvironment,
    required String currency,
    required String? collectionPrimaryKey,
    required String? collectionUserId,
    required String? collectionApiSecret,
    required String? remittanceUserId,
    required String? remittanceApiSecret,
    required String? remittancePrimaryKey,
    required String? disbursementUserId,
    required String? disbursementApiSecret,
    required String? disbursementPrimaryKey,
  })  : _baseUrl = baseUrl,
        _targetEnvironment = targetEnvironment,
        _currency = currency,
        _collectionPrimaryKey = collectionPrimaryKey,
        _collectionUserId = collectionUserId,
        _collectionApiSecret = collectionApiSecret,
        _remittanceUserId = remittanceUserId,
        _remittanceApiSecret = remittanceApiSecret,
        _remittancePrimaryKey = remittancePrimaryKey,
        _disbursementUserId = disbursementUserId,
        _disbursementApiSecret = disbursementApiSecret,
        _disbursementPrimaryKey = disbursementPrimaryKey;

  static get httpClient => _httpClient;

  String? get disbursementPrimaryKey => _disbursementPrimaryKey;

  String? get disbursementApiSecret => _disbursementApiSecret;

  String? get disbursementUserId => _disbursementUserId;

  String? get remittancePrimaryKey => _remittancePrimaryKey;

  String? get remittanceApiSecret => _remittanceApiSecret;

  String? get remittanceUserId => _remittanceUserId;

  String? get collectionApiSecret => _collectionApiSecret;

  String? get collectionUserId => _collectionUserId;

  String? get collectionPrimaryKey => _collectionPrimaryKey;

  String get currency => _currency;

  String get targetEnvironment => _targetEnvironment;

  String get baseUrl => _baseUrl;


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
        throw Exception("");
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
}
