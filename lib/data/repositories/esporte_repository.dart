import 'package:reserva_eventos/data/database/daos/esporte_dao.dart';

class EsporteRepository {
  final EsporteDao _dao;
  EsporteRepository(this._dao);

  Future<List<Map<String, dynamic>>> listarEsportes() async {
    return _dao.getAll();
  }
}
