import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cidade_viewmodel.dart';

class CadastroCidadePage extends StatelessWidget {
  const CadastroCidadePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CidadeViewModel>();
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro de Cidades")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Nome da Cidade"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  await vm.salvar(controller.text);
                  controller.clear();
                }
              },
              child: const Text("Salvar"),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: vm.cidades.length,
                itemBuilder: (_, i) {
                  final cidade = vm.cidades[i];
                  return ListTile(title: Text(cidade.nomeCidade));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
