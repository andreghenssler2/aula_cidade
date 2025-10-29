import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final PreferencesService _prefs = PreferencesService();
  bool _usarFirebase = false;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPreferencia();
  }

  Future<void> _carregarPreferencia() async {
    final valor = await _prefs.getUsarFirebase();
    setState(() {
      _usarFirebase = valor;
      _carregando = false;
    });
  }

  Future<void> _atualizarPreferencia(bool valor) async {
    await _prefs.setUsarFirebase(valor);
    setState(() {
      _usarFirebase = valor;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          valor
              ? 'Persistência alterada para Firebase'
              : 'Persistência alterada para armazenamento local',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Modo de persistência',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text(
                'Usar Firebase (desmarque para salvar localmente)',
              ),
              value: _usarFirebase,
              onChanged: _atualizarPreferencia,
            ),
            const SizedBox(height: 20),
            Text(
              'Atualmente salvando em: ${_usarFirebase ? 'Firebase' : 'SQLite Local'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
