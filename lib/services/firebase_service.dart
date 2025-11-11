import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/midia_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Midia>> listarMidias() {
    return _firestore
        .collection('midias')
        .orderBy('data_upload', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Midia.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> salvarMidia(Midia midia) async {
    await _firestore.collection('midias').doc(midia.id).set(midia.toMap());
  }

  Future<void> deletarMidia(String id) async {
    await _firestore.collection('midias').doc(id).delete();
  }
}
