import 'package:flutter/material.dart';
import 'package:hackerearth_mtn_bj_2022/models/models.dart';

extension TransactionTypeExtension on TransactionType{
  String toShortString() {
    return toString().split('.').last;
  }

  static TransactionType fromString(String type){
    return TransactionType.values.firstWhere((element) => element.toShortString()==type);
  }
}

extension UserRoleExtension on UserRole{
  static UserRole fromString(String role){
    return UserRole.values.firstWhere((element) => element.name==role);
  }
}

extension ThriftDateExtension on ThriftDate{

  String toIntl(){
    switch(this){
      case ThriftDate.oneMonth:
        return "1 mois";
      case ThriftDate.threeMonth:
        return "3 mois";
      case ThriftDate.sixMonth:
        return "6 mois";
      case ThriftDate.nineYear:
        return "9 mois";
      case ThriftDate.oneYear:
        return "1 ans";
      case ThriftDate.twoYear:
        return "2 ans";
      case ThriftDate.threeYear:
        return "3 ans";
    }
  }

  DateTime toDateTime(){
    DateTime l(Duration duration){
      return DateTime.now().add(duration);
    }
    switch(this){
      case ThriftDate.oneMonth:
        return l(const Duration(days: 30));
      case ThriftDate.threeMonth:
        return l(const Duration(days: 30*3));
      case ThriftDate.sixMonth:
        return l(const Duration(days: 30*6));
      case ThriftDate.nineYear:
        return l(const Duration(days: 30*9));
      case ThriftDate.oneYear:
        return l(const Duration(days: 30*12));
      case ThriftDate.twoYear:
        return l(const Duration(days: 30*24));
      case ThriftDate.threeYear:
        return l(const Duration(days: 30*36));
    }
  }
}

extension TransactionStatusExtension on TransactionStatus{
  static TransactionStatus fromString(String s){
    return TransactionStatus.values.firstWhere((element) => element.name==s);
  }

  Color getColor(){
    if(this==TransactionStatus.successful){
      return Colors.greenAccent;
    }else if([TransactionStatus.timeout, TransactionStatus.rejected, TransactionStatus.failed].contains(this)){
      return Colors.pinkAccent;
    }else{
      return Colors.orange;
    }
  }

  IconData getIcon(){
    if(this==TransactionStatus.successful){
      return Icons.done;
    }else if([TransactionStatus.timeout, TransactionStatus.rejected, TransactionStatus.failed].contains(this)){
      return Icons.close;
    }else{
      return Icons.access_time_sharp;
    }
  }

  String toIntl(){
    switch(this){

      case TransactionStatus.pending:
        return "en attente";
      case TransactionStatus.successful:
        return "succès";
      case TransactionStatus.failed:
        return "échec";
      case TransactionStatus.rejected:
        return "rejetée";
      case TransactionStatus.timeout:
        return "expirée";
      case TransactionStatus.ongoing:
        return "en attente";
    }
  }

}