import 'package:reserva_eventos/data/database/daos/quadra_dao.dart';

class QuadraRepository {
  final QuadraDAO _dao;
  QuadraRepository(this._dao);

  Future<List<Map<String, dynamic>>> listarPorEsporteECidade(int esporteId, int cidadeId){
    return _dao.listarPorEsporteECidade(esporteId: esporteId,cidadeId: cidadeId);
  }

  Future<List<Map<String, dynamic>>> listarHorariosBaseDoDia(int quadraId, int diaSemana) {
    return _dao.listarHorariosBaseDoDia(quadraId: quadraId,diaSemana: diaSemana);
  }

  Future<List<Map<String, dynamic>>> listarReservasNaData(int quadraId, String data) {
    return _dao.listarReservasNaData(quadraId: quadraId, data: data);
  }
}
