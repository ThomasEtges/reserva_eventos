import 'package:reserva_eventos/data/database/app_database.dart';

class EventoDetalhesDAO {
  Future<Map<String, dynamic>?> buscarPorId(int eventoId) async {
    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery('''
      SELECT 
        e.id AS evento_id,
        e.nome AS evento_nome,
        e.descricao,
        e.data_hora_inicio,
        e.data_hora_fim,
        e.visibilidade,
        e.genero,
        e.idade_min,
        e.idade_max,
        e.status,
        e.fk_id_criador,
        es.nome AS esporte_nome,
        u.nome AS criador_nome,
        q.nome AS quadra_nome,
        est.nome AS estabelecimento_nome
      FROM eventos e
      JOIN esportes es ON es.id = e.fk_id_esporte
      JOIN usuarios u ON u.id = e.fk_id_criador
      JOIN estabelecimentos est ON est.id = e.fk_id_estabelecimento
      JOIN quadras q ON q.fk_id_estabelecimento = est.id
      WHERE e.id = ?
      LIMIT 1;
    ''', [eventoId]);

    if (result.isEmpty) return null;
    return result.first;
  }

  Future<List<Map<String, dynamic>>> listarParticipantes(int eventoId) async {
    final db = await AppDatabase.instance.database;
    return db.rawQuery('''
      SELECT u.id, u.nome
      FROM eventos_participantes p
      INNER JOIN usuarios u ON u.id = p.fk_id_usuario
      WHERE p.fk_id_evento = ?
      ORDER BY u.nome;
    ''', [eventoId]);
  }

  Future<void> excluirEvento(int eventoId) async {
  final db = await AppDatabase.instance.database;

    await db.transaction((txn) async {
      await txn.delete(
        'quadra_reservas',
        where: 'fk_id_evento = ?',
        whereArgs: [eventoId],
      );

      await txn.delete(
        'eventos_participantes',
        where: 'fk_id_evento = ?',
        whereArgs: [eventoId],
      );

      await txn.delete(
        'eventos',
        where: 'id = ?',
        whereArgs: [eventoId],
      );
    });
  }

}
