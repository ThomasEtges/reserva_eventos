import 'package:reserva_eventos/data/database/app_database.dart';
import 'package:reserva_eventos/data/models/grupo_esporte.dart';
import 'package:sqflite/sqflite.dart';

class GrupoEsportesDao {
  Future<int> insert(GrupoEsporte grupoEsporte) async {
    final db = await AppDatabase.instance.database;
    return db.insert(
      'grupos_esportes',
      grupoEsporte.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await AppDatabase.instance.database;
    return await db.query('grupos_esportes', orderBy: 'nome ASC');
  }

  Future<void> participarDoGrupo(int userId, int grupoId) async {
    final db = await AppDatabase.instance.database;
    await db.insert('grupos_esportes_participantes', {
      'fk_id_usuario': userId,
      'fk_id_grupo_esportes': grupoId,
      'papel': 'membro',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> sairDoGrupo(int userId, int grupoId) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'grupos_esportes_participantes',
      where: 'fk_id_usuario = ? AND fk_id_grupo_esportes = ?',
      whereArgs: [userId, grupoId],
    );
  }

  Future<int> criarGrupo({
    required String nome,
    required int fkIdEsporte,
    required int fkIdCidade,
    required int fkIdCriador,
    required String descricao,
    required String visibilidade,
  }) async {
    final db = await AppDatabase.instance.database;

    final grupoId = await db.insert('grupos_esportes', {
      'nome': nome,
      'fk_id_esporte': fkIdEsporte,
      'fk_id_cidade': fkIdCidade,
      'fk_id_criador': fkIdCriador,
      'descricao': descricao,
      'visibilidade': visibilidade,
    }, conflictAlgorithm: ConflictAlgorithm.abort);

    await db.insert('grupos_esportes_participantes', {
      'fk_id_usuario': fkIdCriador,
      'fk_id_grupo_esportes': grupoId,
      'papel': 'criador',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    return grupoId;
  }
}
