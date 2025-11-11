import 'package:reserva_eventos/data/database/daos/evento_participante_dao.dart';

class EventoParticipanteRepository {
  final EventoParticipanteDAO _dao;
  EventoParticipanteRepository(this._dao);

  Future<bool> jaParticipa(int userId, int eventoId) {
    return _dao.jaParticipa(userId: userId, eventoId: eventoId);
  }

  Future<int> adicionarParticipante(int userId, int eventoId) {
    return _dao.adicionarParticipante(userId: userId, eventoId: eventoId);
  }
}
