import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackerearth_mtn_bj_2022/models/models.dart' as models;

Future<List<dynamic>> processUserQuery(FirebaseFirestore instance, QuerySnapshot<Map<String, dynamic>> query, String usersCollectionName,) async {
  final docs = query.docs.map((doc) => processSimpleDocument(doc));
  return docs.toList();
}

Map<String, dynamic> processSimpleDocument(DocumentSnapshot<Map<String, dynamic>> doc){
  final data = doc.data()!;

  data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
  data['id'] = doc.id;
  data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

  return data;
}

