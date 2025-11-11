import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:reserva_eventos/data/database/daos/user_dao.dart';
import 'package:reserva_eventos/data/repositories/grupo_esportes_repository.dart';
import 'package:reserva_eventos/data/database/daos/grupo_esportes_dao.dart';
import 'package:reserva_eventos/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GrupoEsportesController {
  final grupoEsportesRepo = GrupoEsportesRepository(GrupoEsportesDao());
  final UserRepo = UserRepository(UserDAO());

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<List<Map<String, dynamic>>> listarGrupos() async {
    final userId = await getUserId();
    if (userId == null) return [];
    return UserRepo.listarGrupos(userId);
  }

  Future<void> alternarParticipacao(int grupoId, bool participa) async {
    final userId = await getUserId();
    if (userId != null) {
      if (participa) {
        await grupoEsportesRepo.sair(userId, grupoId);
      } else {
        await grupoEsportesRepo.participar(userId, grupoId);
      }
    }
  }

  Future<void> cadastroGrupoEsporte({
    required BuildContext context,
    required String nome,
    required int fkIdEsporte,
    required int fkIdCidade,
    required String descricao,
    required String visibilidade,
  }) async {
    final userId = await getUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não identificado. Faça login novamente.'),
        ),
      );
      return;
    }

    if (nome.isEmpty ||
        fkIdEsporte <= 0 ||
        fkIdCidade <= 0 ||
        visibilidade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente.')),
      );
      return;
    }

    if (nome.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nome muito curto')));
      return;
    }

    try {
      await grupoEsportesRepo.create(
        nome: nome,
        fkIdEsporte: fkIdEsporte,
        fkIdCidade: fkIdCidade,
        fkIdCriador: userId,
        descricao: descricao,
        visibilidade: visibilidade,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Grupo de esportes cadastrado com sucesso!'),
        ),
      );

      Navigator.pop(context, true);

      Modular.to.navigate('/home/');

    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao cadastrar: $e')));
    }
  }

  Future<void> criarGrupoEsporteDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não encontrado. Faça login novamente.'),
        ),
      );
      return;
    }

    final fkIdCidade = await UserRepo.buscarCidadeUsuario(userId);
    final esportesFavoritos = await UserRepo.buscarEsportesFavoritos(userId);

    if (fkIdCidade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cidade do usuário não encontrada.')),
      );
      return;
    }

    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();
    String visibilidade = 'publico';
    int? fkIdEsporte;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Cadastrar grupo de esporte'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nome do grupo",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descricaoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Descrição",
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Esporte',
                      ),
                      value: fkIdEsporte,
                      items: esportesFavoritos.map((e) {
                        return DropdownMenuItem<int>(
                          value: e['id'] as int,
                          child: Text(e['nome'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => fkIdEsporte = value);
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Visibilidade',
                      ),
                      value: visibilidade,
                      items: const [
                        DropdownMenuItem(
                          value: 'publico',
                          child: Text('Público'),
                        ),
                        DropdownMenuItem(
                          value: 'privado',
                          child: Text('Privado'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => visibilidade = value);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nome = nomeController.text.trim();
                    final descricao = descricaoController.text.trim();

                    if (nome.isEmpty ||
                        descricao.isEmpty ||
                        fkIdEsporte == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Preencha todos os campos.'),
                        ),
                      );
                      return;
                    }

                    cadastroGrupoEsporte(
                      context: context,
                      nome: nome,
                      fkIdEsporte: fkIdEsporte!,
                      fkIdCidade: fkIdCidade,
                      descricao: descricao,
                      visibilidade: visibilidade,
                    );
                    
                  },
                  child: const Text('Criar grupo'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
