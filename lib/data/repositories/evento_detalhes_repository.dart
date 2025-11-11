import 'package:reserva_eventos/data/database/daos/evento_detalhes_dao.dart';

class EventoDetalhesRepository {
  final EventoDetalhesDAO _dao;
  EventoDetalhesRepository(this._dao);

  Future<Map<String, dynamic>?> buscarPorId(int eventoId){
     return _dao.buscarPorId(eventoId);
      }

  Future<List<Map<String, dynamic>>> listarParticipantes(int eventoId){ 
      return _dao.listarParticipantes(eventoId);
      }

  Future<void> excluirEvento(int eventoId) {
  return _dao.excluirEvento(eventoId);
  }

}
