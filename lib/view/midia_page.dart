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

          return ListView.builder(
            itemCount: midias.length,
            itemBuilder: (context, index) {
              final midia = midias[index];
              return ListTile(
                leading: const Icon(Icons.image),
                title: Text(midia.rotulo),
                subtitle: Text(midia.nomeArquivo),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => vm.deletarMidia(midia.id),
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
