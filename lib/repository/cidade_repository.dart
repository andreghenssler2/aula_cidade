import 'package:sqflite/sqflite.dart';
import '../db/db_helper.dart';
import '../model/cidade.dart';

class CidadeRepository {
  Future<Database> get _db async => await DatabaseHelper.instance.database;

  Future<int> inserir(Cidade cidade) async {
    final db = await _db;
    return await db.insert('cidades', cidade.toMap());
  }

  Future<List<Cidade>> listar([String filtro = '']) async {
    final db = await _db;
    final result = await db.query(
      'cidades',
      where: filtro.isNotEmpty ? 'nomeCidade LIKE ?' : null,
      whereArgs: filtro.isNotEmpty ? ['%$filtro%'] : null,
      orderBy: 'nomeCidade ASC',
    );
    return result.map((e) => Cidade.fromMap(e)).toList();
  }
}
