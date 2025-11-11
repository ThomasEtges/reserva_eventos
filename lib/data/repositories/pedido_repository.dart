import 'package:reserva_eventos/data/database/daos/pedido_dao.dart';

class PedidoRepository {
  final PedidoDAO _dao;
  PedidoRepository(this._dao);

  Future<bool> existePedidoEvento(int userId, int eventoId) {
    return _dao.existePedidoEvento(userId: userId, eventoId: eventoId);
  }

  Future<int> criarPedidoEvento(int userId, int eventoId, int destinatarioId) {
    return _dao.criarPedidoEvento(
      userId: userId,
      eventoId: eventoId,
      destinatarioId: destinatarioId,
    );
  }

  Future<List<Map<String, dynamic>>> listarPedidosEvento(int eventoId, int criadorId) {
  return _dao.listarPedidosEvento(eventoId: eventoId, criadorId: criadorId);
}

Future<void> excluirPedido(int pedidoId) {
  return _dao.excluirPedido(pedidoId);
}

}
