import 'package:reserva_eventos/data/database/daos/evento_dao.dart';
import 'package:reserva_eventos/data/models/evento.dart';

class EventoRepository {
  final EventoDAO _dao;
  EventoRepository(this._dao);

  Future<int> create(Evento evento) async {
    return _dao.insert(evento);
  }

  Future<List<Map<String, dynamic>>> buscarEventos(int userId) {
    return _dao.buscarEventosPorUsuario(userId);
  }
}
