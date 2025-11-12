import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:reserva_eventos/data/database/daos/user_dao.dart';
import 'package:reserva_eventos/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final UserRepository _repository = UserRepository(UserDAO());
  final UserDAO _dao = UserDAO();

  Future<void> login(BuildContext context, String email, String senha) async {
    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha e-mail e senha.')));
      return;
    }

    try {
      final user = await _repository.login(email, senha);

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail ou senha inválidos.')),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', user.id!);
      await prefs.setString('user_name', user.nome);

      final participa = await _dao.participaDeAlgumGrupo(user.id!);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bem-vindo, ${user.nome}!')));

      if (participa) {
        Modular.to.navigate('/home/');
      } else {
        Modular.to.navigate('/grupos_esportes/');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao fazer login: $e')));
    }
  }
}
