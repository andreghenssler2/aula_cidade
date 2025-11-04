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
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _loading = false;

  Future<void> _loginComEmailSenha() async {
    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ListaClientesPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg;
      if (e.code == 'user-not-found') {
        msg = 'Usuário não encontrado.';
      } else if (e.code == 'wrong-password') {
        msg = 'Senha incorreta.';
      } else {
        msg = 'Erro: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Login por e-mail/senha ---
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.email),
                      label: const Text('Entrar com E-mail'),
                      onPressed: _loginComEmailSenha,
                    ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 30),

              // --- Login com Google ---
              ElevatedButton.icon(
                icon: Image.asset(
                  'assets/google_logo.png',
                  height: 24,
                  width: 24,
                ),
                label: const Text(
                  'Entrar com Google',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
                onPressed: () async {
                  User? user = await authService.signInWithGoogle();
                  if (user != null && mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ListaClientesPage(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
