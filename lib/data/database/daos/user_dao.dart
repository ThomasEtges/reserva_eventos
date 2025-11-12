import 'package:reserva_eventos/data/database/app_database.dart';
import 'package:reserva_eventos/data/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDAO {
  Future<int> insert(User user) async {
    final db = await AppDatabase.instance.database;
    return db.insert(
      'usuarios',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await AppDatabase.instance.database;
    return await db.query('usuarios', orderBy: 'nome ASC');
  }

  Future<User?> login(String email, String senhaHash) async {
    final db = await AppDatabase.instance.database;
    final res = await db.query(
      'usuarios',
      where: 'email = ? AND senha_hash = ?',
      whereArgs: [email, senhaHash],
      limit: 1,
    );
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  Future<void> vincularEsportes(int userId, List<int> esportesIds) async {
    final db = await AppDatabase.instance.database;

    final batch = db.batch();

    for (final idEsporte in esportesIds) {
      batch.insert('usuario_esportes', {
        'fk_id_usuario': userId,
        'fk_id_esporte': idEsporte,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  Future<bool> participaDeAlgumGrupo(int userId) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'grupos_esportes_participantes',
      where: 'fk_id_usuario = ?',
      whereArgs: [userId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> buscarEsportesFavoritos(int userId) async {
    final db = await AppDatabase.instance.database;
    return db.rawQuery(
      '''
      SELECT e.id, e.nome
      FROM esportes e
      INNER JOIN usuario_esportes ue ON ue.fk_id_esporte = e.id
      WHERE ue.fk_id_usuario = ?
      ORDER BY e.nome ASC
    ''',
      [userId],
    );
  }

  Future<int?> buscarCidadeUsuario(int userId) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'usuarios',
      columns: ['fk_id_cidade'],
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first['fk_id_cidade'] as int : null;
  }

  Future<List<Map<String, dynamic>>> listarGrupos(int userId) async {
    final db = await AppDatabase.instance.database;
    return await db.rawQuery(
      '''
      SELECT
        g.*,
        CASE WHEN p.fk_id_usuario IS NOT NULL THEN 1 ELSE 0 END AS participa
      FROM grupos_esportes g
      LEFT JOIN grupos_esportes_participantes p
        ON p.fk_id_grupo_esportes = g.id AND p.fk_id_usuario = ?
      ORDER BY g.nome ASC
    ''',
      [userId],
    );
  }
}
