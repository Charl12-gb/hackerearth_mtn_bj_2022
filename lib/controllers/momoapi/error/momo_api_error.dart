import 'package:hackerearth_mtn_bj_2022/controllers/momoapi/error/base.dart';

class MomoApiError extends Base{
  MomoApiError({required super.message, super.httpBody, super.httpHeaders, super.httpStatus, super.jsonBody, super.requestId});
}