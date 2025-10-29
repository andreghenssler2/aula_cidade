import 'package:sqflite/sqflite.dart';
import '../db/db_helper.dart';
import '../model/cliente.dart';

class ClienteRepository {
  // 🔹 Retorna lista de todos os clientes
  Future<List<Cliente>> listar() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('clientes', orderBy: 'codigo DESC');
    return result.map((e) => Cliente.fromMap(e)).toList();
  }

  // 🔹 Insere novo cliente
  Future<void> inserir(Cliente cliente) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('clientes', cliente.toMap());
  }

  // 🔹 Atualiza cliente existente
  Future<void> atualizar(Cliente cliente) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'clientes',
      cliente.toMap(),
      where: 'codigo = ?',
      whereArgs: [cliente.codigo],
    );
  }

  // 🔹 Exclui cliente pelo ID
  Future<void> excluir(int codigo) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('clientes', where: 'codigo = ?', whereArgs: [codigo]);
  }
}
