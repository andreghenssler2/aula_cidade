import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'lista_cliente.dart'; // sua tela principal

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Entrar com Google'),
          onPressed: () async {
            User? user = await authService.signInWithGoogle();
            if (user != null && mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ListaClientesPage()),
              );
            }
          },
        ),
      ),
    );
  }
}
