import 'package:reserva_eventos/data/database/daos/evento_dao.dart';

class EventoRepository {
  final EventoDAO _dao;
  EventoRepository(this._dao);

  Future<List<Map<String, dynamic>>> buscarEventos(int userId) {
    return _dao.buscarEventosPorUsuario(userId);
  }
}
