import 'package:reserva_eventos/data/database/daos/grupo_esportes_dao.dart';

class GrupoEsportesRepository {
  final GrupoEsportesDao _dao;
  GrupoEsportesRepository(this._dao);

  Future<List<Map<String, dynamic>>> listarGrupos() async {
    return _dao.getAll();
  }

  Future<void> participar(int userId, int grupoId) async {
    await _dao.participarDoGrupo(userId, grupoId);
  }
}
