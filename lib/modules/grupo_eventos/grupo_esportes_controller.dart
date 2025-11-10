import 'package:reserva_eventos/data/repositories/grupo_esportes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reserva_eventos/data/database/daos/grupo_esportes_dao.dart';

class GrupoEsportesController {
  final repo = GrupoEsportesRepository(GrupoEsportesDao());

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<List<Map<String, dynamic>>> listarGrupos() async {
    return repo.listarGrupos();
  }

  Future<void> participar(int grupoId) async {
    final userId = await getUserId();
    if (userId != null) {
      await repo.participar(userId, grupoId);
    }
  }
}
