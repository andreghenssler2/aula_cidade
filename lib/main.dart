import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'view/login_page.dart';
import 'view/lista_cliente.dart';
import 'view/config_page.dart';
import 'viewmodel/cliente_viewmodel.dart';
import 'viewmodel/cidade_viewmodel.dart';
import 'repository/cidade_repository.dart';
import 'db/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  await DatabaseHelper.instance.database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteViewModel()),
        ChangeNotifierProvider(
          create: (_) => CidadeViewModel(CidadeRepository())..carregar(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Cidades',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}

class HomeMenuPage extends StatelessWidget {
  const HomeMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Gerenciar Clientes'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListaClientesPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Configurações'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConfigPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
