import 'package:flutter/material.dart';

/// Tela popup de busca de cidade
/// Exibe lista de cidades com filtro por nome parcial
class BuscaCidadePopup extends StatefulWidget {
  const BuscaCidadePopup({super.key});

  @override
  State<BuscaCidadePopup> createState() => _BuscaCidadePopupState();
}

class _BuscaCidadePopupState extends State<BuscaCidadePopup> {
  final TextEditingController _filtroController = TextEditingController();

  // Lista simulada de cidades (poderia vir do banco via ViewModel)
  final List<String> _todasCidades = [
    'Rolante',
    'Riozinho',
    'Taquara',
    'Gramado',
    'Canela',
    'Três Coroas',
    'Igrejinha',
    'São Francisco de Paula',
    'Porto Alegre',
  ];

  late List<String> _cidadesFiltradas;

  @override
  void initState() {
    super.initState();
    _cidadesFiltradas = List.from(_todasCidades);
  }

  void _filtrar() {
    setState(() {
      final filtro = _filtroController.text.toLowerCase();
      _cidadesFiltradas = _todasCidades
          .where((c) => c.toLowerCase().contains(filtro))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Buscar Cidade"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _filtroController,
            decoration: const InputDecoration(
              labelText: "Digite o nome da cidade",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (_) => _filtrar(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 300,
            height: 250,
            child: _cidadesFiltradas.isEmpty
                ? const Center(child: Text("Nenhuma cidade encontrada."))
                : ListView.builder(
                    itemCount: _cidadesFiltradas.length,
                    itemBuilder: (_, index) {
                      final cidade = _cidadesFiltradas[index];
                      return ListTile(
                        title: Text(cidade),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.pop(context, cidade);
                          },
                          child: const Text("Selecionar"),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Fechar"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _filtroController.dispose();
    super.dispose();
  }
}
