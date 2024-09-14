import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addCity(String name) async {
    await db.collection('cities').add({'name': name});
  }
}
