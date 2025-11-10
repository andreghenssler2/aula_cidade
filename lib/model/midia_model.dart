import 'package:cloud_firestore/cloud_firestore.dart';
class MidiaModel {
  final String id;
  final String url;
  final String label;
  final String tipo;
  final DateTime? data;

  MidiaModel({
    required this.id,
    required this.url,
    required this.label,
    required this.tipo,
    this.data,
  });

  // Construtor para converter do Firestore
  factory MidiaModel.fromMap(String id, Map<String, dynamic> map) {
    return MidiaModel(
      id: id,
      url: map['url'] ?? '',
      label: map['label'] ?? '',
      tipo: map['tipo'] ?? '',
      data: (map['data'] as Timestamp?)?.toDate(),
    );
  }

  // 👇 Adicione este método para enviar ao Firestore
  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'label': label,
      'tipo': tipo,
      'data': data ?? DateTime.now(),
    };
  }
}
