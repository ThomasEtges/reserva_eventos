import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:reserva_eventos/data/database/daos/cidade_dao.dart';
import 'package:reserva_eventos/data/database/daos/esporte_dao.dart';
import 'package:reserva_eventos/data/database/daos/user_dao.dart';
import 'package:reserva_eventos/data/repositories/cidade_repository.dart';
import 'package:reserva_eventos/data/repositories/esporte_repository.dart';
import 'package:reserva_eventos/data/repositories/user_repository.dart';

class CadastroController {
  final UserRepository _repository = UserRepository(UserDAO());
  final CidadeRepository _cidadeRepository = CidadeRepository(CidadeDAO());
  final EsporteRepository _esporteRepository = EsporteRepository(EsporteDao());

  Future<List<Map<String, dynamic>>> carregarCidades() async {
    return _cidadeRepository.listarCidades();
  }

  Future<List<Map<String, dynamic>>> carregarEsportes() async {
    return _esporteRepository.listarEsportes();
  }


  Future<void> cadastroUsuario({
    required BuildContext context,
    required String nome,
    required String email,
    required String senha,
    required String genero,
    required int idade,
    required int fkIdCidade,
    required List<int> esportesSelecionados,
  }) async {
    if (nome.isEmpty ||
        email.isEmpty ||
        senha.isEmpty ||
        genero.isEmpty ||
        idade <= 0 ||
        fkIdCidade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente.')),
      );

      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('E-mail inválido.')));
      return;
    }

    if (senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A senha deve ter pelo menos 6 caracteres.'),
        ),
      );
      return;
    }

    try {
      final user = await _repository.create(
        nome: nome,
        email: email,
        senha: senha,
        genero: genero,
        idade: idade,
        fkIdCidade: fkIdCidade,
      );

      if (user.id != null && esportesSelecionados.isNotEmpty) {
      await UserDAO().vincularEsportes(user.id!, esportesSelecionados);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário $user cadastrado com sucesso!')),
      );

      Modular.to.navigate('/login/');

    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao cadastrar: $e')));
    }
  }

  
}
