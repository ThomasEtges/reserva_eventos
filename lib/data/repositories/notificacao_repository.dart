import 'package:reserva_eventos/data/database/daos/notificacao_dao.dart';

class NotificacaoRepository {
  final NotificacaoDAO _dao;
  NotificacaoRepository(this._dao);

  Future<int> criar(int usuarioId, String mensagem) {
    return _dao.criar(usuarioId: usuarioId, mensagem: mensagem);
  }

  Future<List<Map<String, dynamic>>> listar(int usuarioId) {
    return _dao.listar(usuarioId);
  }

  Future<void> marcarComoLida(int id) {
    return _dao.marcarComoLida(id);
  }

  Future<void> excluirTodas(int usuarioId) {
    return _dao.excluirTodas(usuarioId);
  }
}
