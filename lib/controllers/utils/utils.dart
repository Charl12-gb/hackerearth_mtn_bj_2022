import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:phone_number/phone_number.dart';

Future<List<dynamic>> processUserQuery(FirebaseFirestore instance, QuerySnapshot<Map<String, dynamic>> query, String usersCollectionName,) async {
  final docs = query.docs.map((doc) => processSimpleDocument(doc));
  return docs.toList();
}

Map<String, dynamic> processSimpleDocument(DocumentSnapshot<Map<String, dynamic>> doc){
  final data = doc.data()!;

  data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
  data['id'] = doc.id;
  data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;
  if(data['withdrawalDate']!=null) data['withdrawalDate'] = data['withdrawalDate']?.millisecondsSinceEpoch;

  return data;
}

Future<bool> validatePhoneNumber(number) async {
  try{
    return await PhoneNumberUtil().validate(number, regionCode: "BJ");
  }on PlatformException catch(_){
    return false;
  }
}

String formattedDateTime(DateTime dateTime){
  String formattedDate = DateFormat.yMMMd().format(dateTime);
  return formattedDate;
}
