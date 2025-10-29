import '../model/cliente.dart';
import '../repository/cliente_repository.dart';
import '../repository/cliente_repository_firebase.dart';
import '../services/preferences_service.dart';

class ClienteRepositoryAdapter {
  final _localRepo = ClienteRepository();
  final _firebaseRepo = ClienteRepositoryFirebase();
  final _prefs = PreferencesService();

  Future<bool> get _usarFirebase async => await _prefs.getUsarFirebase();

  Future<void> inserir(Cliente cliente) async {
    if (await _usarFirebase) {
      await _firebaseRepo.inserir(cliente);
    } else {
      await _localRepo.inserir(cliente);
    }
  }

  Future<void> atualizar(Cliente cliente) async {
    if (await _usarFirebase) {
      await _firebaseRepo.atualizar(cliente);
    } else {
      await _localRepo.atualizar(cliente);
    }
  }

  Future<void> excluir(int codigo) async {
    if (await _usarFirebase) {
      await _firebaseRepo.excluir(codigo);
    } else {
      await _localRepo.excluir(codigo);
    }
  }

  Future<List<Cliente>> listar() async {
    if (await _usarFirebase) {
      return await _firebaseRepo.listar();
    } else {
      return await _localRepo.listar();
    }
  }

  /// 🔹 Novo método: retorna todos os clientes (locais + Firebase)
  Future<List<Cliente>> listarTodos() async {
    final locais = await _localRepo.listar();
    final firebase = await _firebaseRepo.listar();
    return [...locais, ...firebase];
  }

  /// 🔹 Força carregar apenas locais
  Future<List<Cliente>> listarLocal() async => await _localRepo.listar();

  /// 🔹 Força carregar apenas do Firebase
  Future<List<Cliente>> listarFirebase() async => await _firebaseRepo.listar();
}
