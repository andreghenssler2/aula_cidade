import 'package:flutter/foundation.dart';
import '../model/cliente.dart';
import '../repository/repository_adapter.dart';

class ClienteViewModel extends ChangeNotifier {
  final ClienteRepositoryAdapter repo = ClienteRepositoryAdapter();
  List<Cliente> clientes = [];

  /// 🔹 Carrega conforme a flag (SharedPreferences)
  Future<void> carregar() async {
    clientes = await repo.listar();
    notifyListeners();
  }

  /// 🔹 Força carregar todos (local + firebase)
  Future<void> carregarTodos() async {
    clientes = await repo.listarTodos();
    notifyListeners();
  }

  /// 🔹 Somente local
  Future<void> carregarLocal() async {
    clientes = await repo.listarLocal();
    notifyListeners();
  }

  /// 🔹 Somente Firebase
  Future<void> carregarFirebase() async {
    clientes = await repo.listarFirebase();
    notifyListeners();
  }

  Future<void> adicionarCliente({
    required String cpf,
    required String nome,
    required String idade,
    required String dataNascimento,
    required String cidadeNascimento,
  }) async {
    await repo.inserir(
      Cliente(
        cpf: cpf,
        nome: nome,
        idade: int.tryParse(idade) ?? 0,
        dataNascimento: dataNascimento,
        cidadeNascimento: cidadeNascimento,
      ),
    );
    await carregarTodos();
  }

  Future<void> editarCliente({
    required int codigo,
    required String cpf,
    required String nome,
    required String idade,
    required String dataNascimento,
    required String cidadeNascimento,
  }) async {
    await repo.atualizar(
      Cliente(
        codigo: codigo,
        cpf: cpf,
        nome: nome,
        idade: int.tryParse(idade) ?? 0,
        dataNascimento: dataNascimento,
        cidadeNascimento: cidadeNascimento,
      ),
    );
    await carregarTodos();
  }

  Future<void> excluirCliente(int codigo) async {
    await repo.excluir(codigo);
    await carregarTodos();
  }
}
