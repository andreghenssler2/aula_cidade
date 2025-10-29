import 'package:flutter/foundation.dart';
import '../repository/cidade_repository.dart';
import '../model/cidade.dart';

class CidadeViewModel extends ChangeNotifier {
  final CidadeRepository repo;
  CidadeViewModel(this.repo);

  List<Cidade> cidades = [];

  // 🔹 Carrega todas as cidades ou filtra por nome parcial
  Future<void> carregar([String filtro = '']) async {
    cidades = await repo.listar(filtro); // << corrigido (listar)
    notifyListeners();
  }

  // 🔹 Salva uma nova cidade
  Future<void> salvar(String nomeCidade) async {
    await repo.inserir(
      Cidade(nomeCidade: nomeCidade),
    ); // << corrigido (inserir)
    await carregar();
  }
}
