import 'package:reserva_eventos/data/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

class GrupoEsportesDao {
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await AppDatabase.instance.database;
    return await db.query('grupos_esportes', orderBy: 'nome ASC');
  }

  Future<void> participarDoGrupo(int userId, int grupoId) async {
    final db = await AppDatabase.instance.database;
    await db.insert(
      'grupos_esportes_participantes',
      {
        'fk_id_usuario': userId,
        'fk_id_grupo_esportes': grupoId,
        'papel': 'membro',
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
