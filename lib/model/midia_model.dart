import 'package:cloud_firestore/cloud_firestore.dart';
class Midia {
  final String id;
  final String url;
  final String nomeArquivo;
  final String rotulo;
  final DateTime dataUpload;

  Midia({
    required this.id,
    required this.url,
    required this.nomeArquivo,
    required this.rotulo,
    required this.dataUpload,
  });

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'nome_arquivo': nomeArquivo,
      'rotulo': rotulo,
      'data_upload': dataUpload,
    };
  }

  factory Midia.fromMap(String id, Map<String, dynamic> map) {
    return Midia(
      id: id,
      url: map['url'] ?? '',
      nomeArquivo: map['nome_arquivo'] ?? '',
      rotulo: map['rotulo'] ?? '',
      dataUpload: (map['data_upload'] is Timestamp)
          ? (map['data_upload'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

/*factory Midia.fromMap(String id, Map<String, dynamic> map) {
    return Midia(
      id: id,
      url: map['url'] ?? '',
      nomeArquivo: map['nome_arquivo'] ?? '',
      rotulo: map['rotulo'] ?? '',
      dataUpload: (map['data_upload'] as Timestamp).toDate(),
    );
  } */

}


