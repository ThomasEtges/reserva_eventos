import 'package:reserva_eventos/data/database/app_database.dart';

class EventoDAO {
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
      AND e.status = 'publico'
      ORDER BY e.data_hora_inicio ASC
    ''', [userId]);
  }
}
