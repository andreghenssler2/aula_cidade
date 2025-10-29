import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cliente_viewmodel.dart';
import '../model/cliente.dart';
import 'busca_cidade_popup.dart';
import '../services/preferences_service.dart';

class CadastroClientePage extends StatefulWidget {
  final Cliente? cliente;
  const CadastroClientePage({super.key, this.cliente});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _cpfController;
  late TextEditingController _nomeController;
  late TextEditingController _idadeController;
  late TextEditingController _dataNascimentoController;
  late TextEditingController _cidadeController;

  @override
  void initState() {
    super.initState();
    _cpfController = TextEditingController(text: widget.cliente?.cpf ?? '');
    _nomeController = TextEditingController(text: widget.cliente?.nome ?? '');
    _idadeController = TextEditingController(
      text: widget.cliente?.idade.toString() ?? '',
    );
    _dataNascimentoController = TextEditingController(
      text: widget.cliente?.dataNascimento ?? '',
    );
    _cidadeController = TextEditingController(
      text: widget.cliente?.cidadeNascimento ?? '',
    );
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nomeController.dispose();
    _idadeController.dispose();
    _dataNascimentoController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  Future<void> _abrirBuscaCidade() async {
    final cidade = await showDialog<String>(
      context: context,
      builder: (_) => const BuscaCidadePopup(),
    );

    if (cidade != null) {
      setState(() {
        _cidadeController.text = cidade;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    // 🔹 Pergunta ao usuário onde deseja salvar
    final escolha = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolher onde salvar'),
        content: const Text(
          'Deseja salvar os dados localmente ou no Firebase?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'local'),
            child: const Text('Local'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'firebase'),
            child: const Text('Firebase'),
          ),
        ],
      ),
    );

    if (escolha == null) return;

    // 🔹 Atualiza flag de persistência
    final prefs = PreferencesService();
    await prefs.setUsarFirebase(escolha == 'firebase');

    final vm = Provider.of<ClienteViewModel>(context, listen: false);

    if (widget.cliente == null) {
      await vm.adicionarCliente(
        cpf: _cpfController.text.trim(),
        nome: _nomeController.text.trim(),
        idade: _idadeController.text.trim(),
        dataNascimento: _dataNascimentoController.text.trim(),
        cidadeNascimento: _cidadeController.text.trim(),
      );
    } else {
      await vm.editarCliente(
        codigo: widget.cliente!.codigo!,
        cpf: _cpfController.text.trim(),
        nome: _nomeController.text.trim(),
        idade: _idadeController.text.trim(),
        dataNascimento: _dataNascimentoController.text.trim(),
        cidadeNascimento: _cidadeController.text.trim(),
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            escolha == 'firebase'
                ? 'Cliente salvo no Firebase!'
                : 'Cliente salvo localmente!',
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o CPF' : null,
              ),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe a idade' : null,
              ),
              TextFormField(
                controller: _dataNascimentoController,
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Informe a data de nascimento'
                    : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cidadeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Cidade de Nascimento',
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Selecione a cidade'
                          : null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _abrirBuscaCidade,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
