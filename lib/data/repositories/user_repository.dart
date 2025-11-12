import '../database/daos/user_dao.dart';
import '../models/user.dart';
import '../../utils/helpers.dart';

class UserRepository {
  final UserDAO _dao;
  UserRepository(this._dao);

  Future<User> create({
    required String nome,
    required String email,
    required String senha,
    required String genero,
    required int idade,
    required int fkIdCidade,
  }) async {
    final user = User(
      nome: nome,
      email: email.trim().toLowerCase(),
      senhaHash: hashPassword(senha),
      genero: genero,
      idade: idade,
      fkIdCidade: fkIdCidade,
    );

    final id = await _dao.insert(user);

    return User(
      id: id,
      nome: user.nome,
      email: user.email,
      senhaHash: user.senhaHash,
      genero: user.genero,
      idade: user.idade,
      fkIdCidade: user.fkIdCidade,
    );
  }

  Future<User?> login(String email, String senha) async {
    final hash = hashPassword(senha);
    return _dao.login(email.trim().toLowerCase(), hash);
  }

  Future<List<Map<String, dynamic>>> buscarEsportesFavoritos(int userId) {
    return _dao.buscarEsportesFavoritos(userId);
  }

  Future<int?> buscarCidadeUsuario(int userId) {
    return _dao.buscarCidadeUsuario(userId);
  }

  Future<List<Map<String, dynamic>>> listarGrupos(int userId) async {
    return _dao.listarGrupos(userId);
  }
}
