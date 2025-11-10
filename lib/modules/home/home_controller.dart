import 'package:reserva_eventos/data/repositories/evento_repository.dart';
import 'package:reserva_eventos/data/database/daos/evento_dao.dart';

class HomeController {
  final repo = EventoRepository(EventoDAO());

  Future<List<Map<String, dynamic>>> buscarEventos(int userId) {
    return repo.buscarEventos(userId);
  }
}
