// models/midia_model.dart
// Representa a mídia (foto ou vídeo) capturada.

class MidiaModel {
  final String caminho; // Caminho do arquivo salvo no dispositivo
  final bool ehVideo; // True se for vídeo, false se for foto

  MidiaModel({required this.caminho, required this.ehVideo});
}
