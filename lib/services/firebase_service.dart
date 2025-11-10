import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/midia_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String tipo) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('midias/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> salvarMidia(MidiaModel midia) async {
    await _firestore.collection('midias').add(midia.toMap());
  }

  Stream<List<MidiaModel>> listarMidias() {
    return _firestore
        .collection('midias')
        .orderBy('data', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MidiaModel.fromMap(doc.id, doc.data()))
            .toList());
  }
}
