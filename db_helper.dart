import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/planeta.dart';

class DBHelper {
  static Database? _database;

  // Acesso ao banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inicializar o banco de dados
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'planetas.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE planetas(id INTEGER PRIMARY KEY, nome TEXT, distancia_do_sol REAL, tamanho INTEGER, apelido TEXT)',
        );
      },
      version: 1,
    );
  }

  // Criar novo planeta
  Future<int> insertPlaneta(Planeta planeta) async {
    final db = await database;
    return await db.insert('planetas', planeta.toMap());
  }

  // Obter todos os planetas
  Future<List<Planeta>> getPlanetas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('planetas');
    return List.generate(maps.length, (i) {
      return Planeta.fromMap(maps[i]);
    });
  }

  // Atualizar planeta
  Future<int> updatePlaneta(Planeta planeta) async {
    final db = await database;
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }

  // Excluir planeta
  Future<int> deletePlaneta(int id) async {
    final db = await database;
    return await db.delete(
      'planetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
