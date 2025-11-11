import 'package:reserva_eventos/data/database/app_database.dart';

class PedidoDAO {
  Future<bool> existePedidoEvento({
    required int userId,
    required int eventoId,
  }) async {
    final db = await AppDatabase.instance.database;
    final res = await db.query(
      'pedidos',
      where:
          'fk_id_usuario = ? AND origem_pedido = ? AND fk_id_origem_pedido = ?',
      whereArgs: [userId, 'evento', eventoId],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  Future<int> criarPedidoEvento({
    required int userId,
    required int eventoId,
    required int destinatarioId,
  }) async {
    final db = await AppDatabase.instance.database;
    return db.insert('pedidos', {
      'fk_id_usuario': userId,
      'fk_id_origem_pedido': eventoId,
      'fk_id_destinatario': destinatarioId,
      'origem_pedido': 'evento',
      'status': 'pendente',
    });
  }

  Future<List<Map<String, dynamic>>> listarPedidosEvento({
  required int eventoId,
  required int criadorId,
}) async {
  final db = await AppDatabase.instance.database;

  return db.rawQuery('''
    SELECT 
      p.id AS pedido_id,
      u.id AS usuario_id,
      u.nome AS usuario_nome,
      p.status
    FROM pedidos p
    INNER JOIN usuarios u ON u.id = p.fk_id_usuario
    WHERE p.fk_id_origem_pedido = ? 
      AND p.fk_id_destinatario = ?
      AND p.origem_pedido = 'evento'
    ORDER BY p.id DESC;
  ''', [eventoId, criadorId]);
}

Future<void> excluirPedido(int pedidoId) async {
  final db = await AppDatabase.instance.database;
  await db.delete('pedidos', where: 'id = ?', whereArgs: [pedidoId]);
}

}
