import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/cliente.dart';

class ClienteRepositoryFirebase {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'clientes',
  );

  Future<void> inserir(Cliente cliente) async {
    await _collection.add(cliente.toMap());
  }

  Future<void> atualizar(Cliente cliente) async {
    final doc = await _collection
        .where('codigo', isEqualTo: cliente.codigo)
        .limit(1)
        .get();
    if (doc.docs.isNotEmpty) {
      await doc.docs.first.reference.update(cliente.toMap());
    }
  }

  Future<void> excluir(int codigo) async {
    final doc = await _collection
        .where('codigo', isEqualTo: codigo)
        .limit(1)
        .get();
    if (doc.docs.isNotEmpty) {
      await doc.docs.first.reference.delete();
    }
  }

  Future<List<Cliente>> listar() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((d) => Cliente.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }
}
