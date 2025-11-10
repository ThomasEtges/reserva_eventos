import 'package:reserva_eventos/data/database/daos/cidade_dao.dart';

class CidadeRepository {
  final CidadeDAO _dao;
  CidadeRepository(this._dao);

  Future<List<Map<String, dynamic>>> listarCidades() async {
    return _dao.getAll();
  }
}
