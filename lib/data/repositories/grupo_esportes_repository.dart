import 'package:reserva_eventos/data/database/daos/grupo_esportes_dao.dart';
import 'package:reserva_eventos/data/models/grupo_esporte.dart';

class GrupoEsportesRepository {
  final GrupoEsportesDao _dao;
  GrupoEsportesRepository(this._dao);

  Future<GrupoEsporte> create({
    required String nome,
    required int fkIdEsporte,
    required int fkIdCidade,
    required int fkIdCriador,
    required String descricao,
    required String visibilidade,
  }) async {
    final grupo = GrupoEsporte(
      nome: nome,
      fkIdEsporte: fkIdEsporte,
      fkIdCidade: fkIdCidade,
      fkIdCriador: fkIdCriador,
      descricao: descricao,
      visibilidade: visibilidade,
    );

    final id = await _dao.insert(grupo);

    await _dao.participarDoGrupo(fkIdCriador, id);

    return GrupoEsporte(
      id: id,
      nome: grupo.nome,
      fkIdEsporte: grupo.fkIdEsporte,
      fkIdCidade: grupo.fkIdCidade,
      fkIdCriador: grupo.fkIdCriador,
      descricao: grupo.descricao,
      visibilidade: grupo.visibilidade,
    );
  }

  Future<List<Map<String, dynamic>>> listarGrupos() async {
    return _dao.getAll();
  }

  Future<void> participar(int userId, int grupoId) async {
    await _dao.participarDoGrupo(userId, grupoId);
  }

  Future<void> sair(int userId, int grupoId) async {
    await _dao.sairDoGrupo(userId, grupoId);
  }
}
