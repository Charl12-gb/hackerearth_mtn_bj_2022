import 'package:hackerearth_mtn_bj_2022/controllers/momoapi/error/base.dart';

class InvalidRequest extends Base{
  InvalidRequest({required super.message, required super.httpStatus, required super.httpBody, required super.jsonBody, required super.httpHeaders});
}