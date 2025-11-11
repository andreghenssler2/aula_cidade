import '../model/midia_model.dart';
import '../services/firebase_service.dart';

class MidiaRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Stream<List<Midia>> listarMidias() => _firebaseService.listarMidias();

  Future<void> salvarMidia(Midia midia) => _firebaseService.salvarMidia(midia);

  Future<void> deletarMidia(String id) => _firebaseService.deletarMidia(id);
}
