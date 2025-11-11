import 'package:reserva_eventos/data/database/app_database.dart';
import 'package:reserva_eventos/data/models/evento.dart';
import 'package:sqflite/sqflite.dart';

class EventoDAO {

  Future<int> insert(Evento evento) async {
    final db = await AppDatabase.instance.database;
    return db.insert(
      'eventos',
      evento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await AppDatabase.instance.database;
    return db.query('eventos', orderBy: 'data_hora_inicio ASC');
  }

  Future<List<Map<String, dynamic>>> buscarEventosPorUsuario(int userId) async {
    final db = await AppDatabase.instance.database;

    return db.rawQuery('''
      SELECT e.*
      FROM eventos e
      WHERE e.fk_id_grupo_esportes IN (
        SELECT g.fk_id_grupo_esportes
        FROM grupos_esportes_participantes g
        WHERE g.fk_id_usuario = ?
      )
      ORDER BY e.data_hora_inicio ASC
    ''', [userId]);
  }
}
