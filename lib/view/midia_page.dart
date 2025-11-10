import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/midia_viewmodel.dart';
import '../model/midia_model.dart';

class MidiaPage extends StatelessWidget {
  const MidiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MidiaViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Captura e Upload de Mídia')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (vm.arquivo != null)
              vm.tipo == 'imagem'
                  ? Image.file(vm.arquivo!, height: 180)
                  : const Icon(Icons.videocam, size: 180),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Rótulo ou descrição da mídia'),
              onChanged: (v) => vm.label = v,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => vm.selecionarMidia(),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Foto'),
                ),
                ElevatedButton.icon(
                  onPressed: () => vm.selecionarMidia(isVideo: true),
                  icon: const Icon(Icons.videocam),
                  label: const Text('Vídeo'),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: vm.enviando ? null : vm.enviarMidia,
              icon: const Icon(Icons.cloud_upload),
              label: Text(vm.enviando ? 'Enviando...' : 'Enviar'),
            ),
            const Divider(height: 30),
            const Text(
              'Mídias Enviadas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(
              child: StreamBuilder<List<MidiaModel>>(
                stream: vm.midias,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final midias = snapshot.data!;
                  if (midias.isEmpty) {
                    return const Center(child: Text('Nenhuma mídia ainda.'));
                  }

                  return ListView.builder(
                    itemCount: midias.length,
                    itemBuilder: (context, index) {
                      final m = midias[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: m.tipo == 'imagem'
                              ? Image.network(m.url, width: 60, fit: BoxFit.cover)
                              : const Icon(Icons.videocam),
                          title: Text(m.label),
                          subtitle: Text(m.tipo),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
