import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../model/midia_model.dart';
import '../repository/midia_repository.dart';
import '../services/azure_service.dart';

class MidiaViewModel extends ChangeNotifier {
  final MidiaRepository _repository = MidiaRepository();
  final AzureService _azureService = AzureService();
  final ImagePicker _picker = ImagePicker();

  Stream<List<Midia>> listarMidias() => _repository.listarMidias();

  Future<void> capturarMidia({required bool video, required String rotulo}) async {
    final XFile? arquivo = await (video
        ? _picker.pickVideo(source: ImageSource.camera)
        : _picker.pickImage(source: ImageSource.camera));

    if (arquivo == null) return;

    final file = File(arquivo.path);

    // 1️⃣ Envia para o Azure Blob Storage
    final url = await _azureService.uploadFileToAzure(file);
    if (url == null) return;

    // 2️⃣ Cria objeto Midia com a URL
    final novaMidia = Midia(
      id: const Uuid().v4(),
      url: url,
      nomeArquivo: arquivo.name,
      rotulo: rotulo,
      dataUpload: DateTime.now(),
    );

    // 3️⃣ Salva no Firestore (só metadados)
    await _repository.salvarMidia(novaMidia);
    notifyListeners();
  }

  Future<void> deletarMidia(String id) async {
    await _repository.deletarMidia(id);
    notifyListeners();
  }
}
