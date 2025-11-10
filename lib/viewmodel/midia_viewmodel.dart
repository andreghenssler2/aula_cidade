import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/midia_model.dart';

class MidiaViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  File? arquivo;
  String tipo = '';
  String label = '';
  bool enviando = false;

  // Stream das mídias no Firestore
  Stream<List<MidiaModel>> get midias {
    return FirebaseFirestore.instance
        .collection('midias')
        .orderBy('data', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MidiaModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Seleciona imagem ou vídeo
  Future<void> selecionarMidia({bool isVideo = false}) async {
    final XFile? midia = await (isVideo
        ? _picker.pickVideo(source: ImageSource.camera)
        : _picker.pickImage(source: ImageSource.camera));

    if (midia != null) {
      arquivo = File(midia.path);
      tipo = isVideo ? 'vídeo' : 'imagem';
      notifyListeners();
    }
  }

  // Envia mídia ao Firebase
  Future<void> enviarMidia() async {
    if (arquivo == null) return;

    enviando = true;
    notifyListeners();

    try {
      final nomeArquivo = '${DateTime.now().millisecondsSinceEpoch}_${arquivo!.path.split('/').last}';
      final refStorage = FirebaseStorage.instance.ref().child('midias/$nomeArquivo');

      await refStorage.putFile(arquivo!);
      final url = await refStorage.getDownloadURL();

      await FirebaseFirestore.instance.collection('midias').add({
        'url': url,
        'label': label,
        'tipo': tipo,
        'data': FieldValue.serverTimestamp(),
      });

      arquivo = null;
      label = '';
      tipo = '';
    } catch (e) {
      debugPrint('Erro ao enviar mídia: $e');
    } finally {
      enviando = false;
      notifyListeners();
    }
  }
}
