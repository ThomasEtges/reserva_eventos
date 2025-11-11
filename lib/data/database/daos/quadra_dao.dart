import 'package:reserva_eventos/data/database/app_database.dart';

class QuadraDAO {
  Future<List<Map<String, dynamic>>> listarPorEsporteECidade({
    required int esporteId,
    required int cidadeId,
  }) async {
    final db = await AppDatabase.instance.database;
    return db.rawQuery('''
      SELECT 
        q.id AS quadra_id,
        q.nome AS quadra_nome,
        e.id AS estabelecimento_id,
        e.nome AS estabelecimento_nome
      FROM quadras q
      INNER JOIN estabelecimentos e ON e.id = q.fk_id_estabelecimento
      WHERE q.fk_id_esporte = ? AND e.fk_id_cidade = ?
      ORDER BY e.nome, q.nome;
    ''', [esporteId, cidadeId]);
  }

  Future<List<Map<String, dynamic>>> listarHorariosBaseDoDia({
    required int quadraId,
    required int diaSemana,
  }) async {
    final db = await AppDatabase.instance.database;
    return db.rawQuery('''
      SELECT hora_inicio, hora_fim
      FROM quadra_horarios
      WHERE fk_id_quadra = ? AND dia_semana = ? AND disponivel = 1
      ORDER BY hora_inicio ASC;
    ''', [quadraId, diaSemana]);
  }

  Future<List<Map<String, dynamic>>> listarReservasNaData({
    required int quadraId,
    required String data, 
  }) async {
    final db = await AppDatabase.instance.database;
    return db.rawQuery('''
      SELECT hora_inicio, hora_fim
      FROM quadra_reservas
      WHERE fk_id_quadra = ? AND data = ?
    ''', [quadraId, data]);
  }
}
