import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class AzureService {
  final String storageAccountName = "aulacidadefaccat"; // Exemplo: minhaconta
  final String containerName = "midias";
  final String sasToken =
      "sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2026-01-01T02:55:56Z&st=2025-11-11T22:40:56Z&spr=https&sig=YovtEWuHpD4LCUCL%2FpPppHfwNDnJBAleLBKx0wn%2FLcg%3D"; // Exemplo: "?sv=2024-05-20&ss=b&srt=sco&sp=rwlacup"

  Future<String?> uploadFileToAzure(File file) async {
    try {
      final fileName = path.basename(file.path);
      final uri =
          Uri.parse("https://$storageAccountName.blob.core.windows.net/$containerName/$fileName$sasToken");

      final fileBytes = await file.readAsBytes();

      final response = await http.put(
        uri,
        headers: {
          "x-ms-blob-type": "BlockBlob",
          "Content-Type": "application/octet-stream",
        },
        body: fileBytes,
      );

      if (response.statusCode == 201) {
        print("✅ Upload realizado com sucesso!");
        return "https://$storageAccountName.blob.core.windows.net/$containerName/$fileName";
      } else {
        print("❌ Erro ao fazer upload: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Erro ao enviar para Azure: $e");
      return null;
    }
  }
}
