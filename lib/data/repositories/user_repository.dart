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
    return user.copyWith(id: id);
  }

  Future<User?> login(String email, String senha) async {
    final hash = hashPassword(senha);
    return _dao.login(email.trim().toLowerCase(), hash);
  }
}



extension on User {
  User copyWith({
    int? id,
    String? nome,
    String? email,
    String? senhaHash,
    String? genero,
    int? idade,
    int? fkIdCidade,
  }) {
    return User(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senhaHash: senhaHash ?? this.senhaHash,
      genero: genero ?? this.genero,
      idade: idade ?? this.idade,
      fkIdCidade: fkIdCidade ?? this.fkIdCidade,
    );
  }
}
