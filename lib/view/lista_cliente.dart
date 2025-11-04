import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import '../viewmodel/cliente_viewmodel.dart';
import '../model/cliente.dart';
import '../services/auth_service.dart';
import 'cadastro_cliente_page.dart';
import 'login_page.dart'; // ← para redirecionar após logout

class ListaClientesPage extends StatefulWidget {
  const ListaClientesPage({super.key});

  @override
  State<ListaClientesPage> createState() => _ListaClientesPageState();
}

class _ListaClientesPageState extends State<ListaClientesPage> {
  List<Cliente> clientesLocal = [];
  List<Cliente> clientesFirebase = [];
  bool carregando = true;
  final authService = AuthService(); // ← instância do serviço de autenticação

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    final vm = Provider.of<ClienteViewModel>(context, listen: false);
    clientesLocal = await vm.repo.listarLocal();
    clientesFirebase = await vm.repo.listarFirebase();
    setState(() => carregando = false);
  }

  Future<void> _excluirCliente(Cliente cliente, bool isFirebase) async {
    final vm = Provider.of<ClienteViewModel>(context, listen: false);
    await vm.excluirCliente(cliente.codigo!);
    await _carregarClientes();
  }

  Future<void> _logout() async {
    await authService.signOut(); // faz logout do Firebase (Google/email)
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ExpansionTile(
                  initiallyExpanded: true,
                  leading: const Icon(Icons.storage, color: Colors.grey),
                  title: const Text(
                    'Clientes Locais (SQLite)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: clientesLocal.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Nenhum cliente local encontrado.'),
                          ),
                        ]
                      : clientesLocal.map((c) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              title: Text(c.nome),
                              subtitle: Text(
                                'CPF: ${c.cpf}\nCidade: ${c.cidadeNascimento}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _excluirCliente(c, false),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CadastroClientePage(cliente: c),
                                  ),
                                ).then((_) => _carregarClientes());
                              },
                            ),
                          );
                        }).toList(),
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  leading: const Icon(Icons.cloud, color: Colors.blue),
                  title: const Text(
                    'Clientes Firebase',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: clientesFirebase.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Nenhum cliente Firebase encontrado.'),
                          ),
                        ]
                      : clientesFirebase.map((c) {
                          return Card(
                            color: Colors.blue.withOpacity(0.05),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              title: Text(c.nome),
                              subtitle: Text(
                                'CPF: ${c.cpf}\nCidade: ${c.cidadeNascimento}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _excluirCliente(c, true),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CadastroClientePage(cliente: c),
                                  ),
                                ).then((_) => _carregarClientes());
                              },
                            ),
                          );
                        }).toList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Novo Cliente'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroClientePage()),
          ).then((_) => _carregarClientes());
        },
      ),
    );
  }
}
