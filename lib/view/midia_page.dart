import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/midia_viewmodel.dart';
import '../model/midia_model.dart';

class MidiaPage extends StatefulWidget {
  const MidiaPage({super.key});

  @override
  State<MidiaPage> createState() => _MidiaPageState();
}

class _MidiaPageState extends State<MidiaPage> {
  final TextEditingController _rotuloController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MidiaViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura de Mídia'),
      ),
      body: StreamBuilder<List<Midia>>(
        stream: vm.listarMidias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final midias = snapshot.data ?? [];

          if (midias.isEmpty) {
            return const Center(child: Text('Nenhuma mídia encontrada.'));
          }

          return ListView.builder(
            itemCount: midias.length,
            itemBuilder: (context, index) {
              final midia = midias[index];
              final isVideo = midia.nomeArquivo.toLowerCase().endsWith('.mp4');

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                child: ListTile(
                  leading: isVideo
                      ? const Icon(Icons.videocam, color: Colors.blueAccent)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            midia.url,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                  title: Text(midia.rotulo),
                  subtitle: Text(midia.nomeArquivo),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => vm.deletarMidia(midia.id),
                  ),
                  onTap: () {
                    // Ao clicar, mostra a imagem ou vídeo em tela cheia
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MidiaDetalhePage(midia: midia),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirDialogCaptura(context, vm),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  void _abrirDialogCaptura(BuildContext context, MidiaViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova Mídia'),
        content: TextField(
          controller: _rotuloController,
          decoration: const InputDecoration(labelText: 'Rótulo'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final rotulo = _rotuloController.text.trim();
              if (rotulo.isEmpty) return;
              await vm.capturarMidia(video: false, rotulo: rotulo);
              Navigator.pop(context);
            },
            child: const Text('Foto'),
          ),
          TextButton(
            onPressed: () async {
              final rotulo = _rotuloController.text.trim();
              if (rotulo.isEmpty) return;
              await vm.capturarMidia(video: true, rotulo: rotulo);
              Navigator.pop(context);
            },
            child: const Text('Vídeo'),
          ),
        ],
      ),
    );
  }
}

class MidiaDetalhePage extends StatelessWidget {
  final Midia midia;
  const MidiaDetalhePage({super.key, required this.midia});

  @override
  Widget build(BuildContext context) {
    final isVideo = midia.nomeArquivo.toLowerCase().endsWith('.mp4');

    return Scaffold(
      appBar: AppBar(title: Text(midia.rotulo)),
      body: Center(
        child: isVideo
            ? const Icon(Icons.videocam, size: 100, color: Colors.blueAccent)
            : Image.network(
                midia.url,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80, color: Colors.grey),
              ),
      ),
    );
  }
}
