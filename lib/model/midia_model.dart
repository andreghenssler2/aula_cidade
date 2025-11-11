import 'package:cloud_firestore/cloud_firestore.dart';

class Midia {
  final String id;
  final String url;
  final String nomeArquivo;
  final String rotulo;
  final String? base64Amostra;
  final DateTime dataUpload;

  Midia({
    required this.id,
    required this.url,
    required this.nomeArquivo,
    required this.rotulo,
    this.base64Amostra,
    required this.dataUpload,
  });

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'nome_arquivo': nomeArquivo,
      'rotulo': rotulo,
      'base64_amostra': base64Amostra,
      'data_upload': Timestamp.fromDate(dataUpload),
    };
  }

  factory Midia.fromMap(String id, Map<String, dynamic> map) {
    return Midia(
      id: id,
      url: map['url'] ?? '',
      nomeArquivo: map['nome_arquivo'] ?? '',
      rotulo: map['rotulo'] ?? '',
      base64Amostra: map['base64_amostra'],
      dataUpload: (map['data_upload'] is Timestamp)
          ? (map['data_upload'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}