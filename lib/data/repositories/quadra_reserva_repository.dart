import 'package:reserva_eventos/data/database/daos/quadra_reserva_dao.dart';

class QuadraReservaRepository {
  final QuadraReservaDAO _dao;
  QuadraReservaRepository(this._dao);

  Future<int> criarReserva({
    required int eventoId,
    required int quadraId,
    required String data,
    required String horaInicio,
    required String horaFim,
  }) {
    return _dao.criarReserva(
      eventoId: eventoId,
      quadraId: quadraId,
      data: data,
      horaInicio: horaInicio,
      horaFim: horaFim,
    );
  }
}
