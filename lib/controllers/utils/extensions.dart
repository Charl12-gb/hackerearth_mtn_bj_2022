import 'package:hackerearth_mtn_bj_2022/models/models.dart';

extension TransactionTypeExtension on TransactionType{
  String toShortString() {
    return toString().split('.').last;
  }

  TransactionType fromString(String role){
    return TransactionType.values.firstWhere((element) => element.toShortString()==role);
  }
}

extension UserRoleExtension on UserRole{
  static UserRole fromString(String role){
    return UserRole.values.firstWhere((element) => element.name==role);
  }
}