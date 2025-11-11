import 'package:reserva_eventos/data/database/app_database.dart';

class EventoParticipanteDAO {
  Future<bool> jaParticipa({
    required int userId,
    required int eventoId,
  }) async {
    final db = await AppDatabase.instance.database;
    final res = await db.query(
      'eventos_participantes',
      where: 'fk_id_evento = ? AND fk_id_usuario = ?',
      whereArgs: [eventoId, userId],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  Future<int> adicionarParticipante({
    required int userId,
    required int eventoId,
  }) async {
    final db = await AppDatabase.instance.database;
    return db.insert('eventos_participantes', {
      'fk_id_evento': eventoId,
      'fk_id_usuario': userId,
      'papel': 'participante',
    });
  }
}
