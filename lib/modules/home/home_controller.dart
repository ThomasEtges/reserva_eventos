import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:reserva_eventos/data/repositories/evento_repository.dart';
import 'package:reserva_eventos/data/repositories/user_repository.dart';
import 'package:reserva_eventos/data/repositories/quadra_repository.dart';
import 'package:reserva_eventos/data/repositories/quadra_reserva_repository.dart';

import 'package:reserva_eventos/data/database/daos/evento_dao.dart';
import 'package:reserva_eventos/data/database/daos/user_dao.dart';
import 'package:reserva_eventos/data/database/daos/quadra_dao.dart';
import 'package:reserva_eventos/data/database/daos/quadra_reserva_dao.dart';

import 'package:reserva_eventos/data/models/evento.dart';

class HomeController {
  final repoEvento = EventoRepository(EventoDAO());
  final repoUser = UserRepository(UserDAO());
  final repoQuadra = QuadraRepository(QuadraDAO());
  final repoReserva = QuadraReservaRepository(QuadraReservaDAO());

  Future<List<Map<String, dynamic>>> buscarEventos(int userId) {
    return repoEvento.buscarEventos(userId);
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> abrirCriarEventoDialog(BuildContext context) async {
    final userId = await _getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não identificado.')),
      );
      return;
    }

    final grupos = await repoUser.listarGrupos(userId);
    if (grupos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Participe de um grupo para criar eventos.'),
        ),
      );
      return;
    }
 
    final nomeCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    int? grupoSelId;
    int? quadraSelId;
    Map<String, dynamic>? grupoSel;
    Map<String, dynamic>? quadraSel;
    List<Map<String, dynamic>> quadras = [];
    List<Map<String, dynamic>> horariosDisp = [];

    DateTime? dataSel;
    String? horaInicioSel; 
    String? horaFimSel;

    String visibilidade = 'publico';
    String genero = 'misto';
    int? idadeMin;
    int? idadeMax;

    final df = DateFormat('dd/MM/yyyy');

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          Future<void> _carregarQuadrasDoGrupo() async {
            if (grupoSel == null) return;
            final esporteId = grupoSel!['fk_id_esporte'] as int;
            final cidadeId = grupoSel!['fk_id_cidade'] as int;

            final res = await repoQuadra.listarPorEsporteECidade(
              esporteId,
              cidadeId,
            );

            setState(() {
              quadras = res;
              quadraSel = null;
              horariosDisp = [];
              horaInicioSel = null;
              horaFimSel = null;
            });
          }

          Future<void> _carregarHorariosDisponiveis() async {
            if (quadraSel == null || dataSel == null) return;

            final quadraId = quadraSel!['quadra_id'] as int;

            final weekday = dataSel!.weekday;

            final base = await repoQuadra.listarHorariosBaseDoDia(
              quadraId,
              weekday,
            );

            final data = DateFormat('yyyy-MM-dd').format(dataSel!);
            final reservas = await repoQuadra.listarReservasNaData(
              quadraId,
              data,
            );

            bool conflita(String aIni, String aFim, String bIni, String bFim) {
              return !(aFim.compareTo(bIni) <= 0 || aIni.compareTo(bFim) >= 0);
            }

            final livres = <Map<String, dynamic>>[];
            for (final slot in base) {
              final sIni = slot['hora_inicio'] as String;
              final sFim = slot['hora_fim'] as String;

              final temConflito = reservas.any((r) {
                final rIni = r['hora_inicio'] as String;
                final rFim = r['hora_fim'] as String;
                return conflita(sIni, sFim, rIni, rFim);
              });

              if (!temConflito) {
                livres.add({'hora_inicio': sIni, 'hora_fim': sFim});
              }
            }

            setState(() {
              horariosDisp = livres;
              horaInicioSel = null;
              horaFimSel = null;
            });
          }

          return AlertDialog(
            title: const Text('Criar evento'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Grupo de esporte',
                    ),
                    value: grupoSelId,
                    items: grupos.map((g) {
                      return DropdownMenuItem<int>(
                        value: g['id'] as int,
                        child: Text(g['nome'] as String),
                      );
                    }).toList(),
                    onChanged: (id) {
                      setState(() {
                        grupoSelId = id;
                        grupoSel = grupos.firstWhere((g) => g['id'] == id);
                      });
                      _carregarQuadrasDoGrupo();
                    },
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quadra',
                    ),
                    value: quadraSelId,
                    items: quadras.map(
                      (q) => DropdownMenuItem<int>(
                        value: q['quadra_id'] as int,
                        child: Text('${q['estabelecimento_nome']} - ${q['quadra_nome']}'),
                      ),
                    ).toList(),
                    onChanged: (id) {
                      setState(() {
                        quadraSelId = id;
                        quadraSel = quadras.firstWhere((q) => q['quadra_id'] == id);
                      });
                      _carregarHorariosDisponiveis();
                    },
                  ),
                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () async {
                      final d = await showDatePicker(
                        context: ctx,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2026, 12, 31),
                        initialDate: DateTime.now(),
                      );
                      if (d != null) {
                        setState(() => dataSel = d);
                        _carregarHorariosDisponiveis();
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        dataSel == null
                            ? 'Selecionar data'
                            : df.format(dataSel!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Hora início',
                    ),
                    value: horaInicioSel,
                    items: horariosDisp
                        .map(
                          (h) => DropdownMenuItem(
                            value: h['hora_inicio'] as String,
                            child: Text(h['hora_inicio'] as String),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => horaInicioSel = v),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Hora fim',
                    ),
                    value: horaFimSel,
                    items: horariosDisp
                        .map(
                          (h) => DropdownMenuItem(
                            value: h['hora_fim'] as String,
                            child: Text(h['hora_fim'] as String),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => horaFimSel = v),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome do evento',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Descrição',
                    ),
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
                    onChanged: (v) => visibilidade = v ?? 'publico',
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Gênero',
                    ),
                    value: genero,
                    items: const [
                      DropdownMenuItem(value: 'misto', child: Text('Misto')),
                      DropdownMenuItem(
                        value: 'masculino',
                        child: Text('Masculino'),
                      ),
                      DropdownMenuItem(
                        value: 'feminino',
                        child: Text('Feminino'),
                      ),
                    ],
                    onChanged: (v) => genero = v ?? 'misto',
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Idade mín. (opcional)',
                          ),
                          onChanged: (v) => idadeMin = int.tryParse(v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Idade máx. (opcional)',
                          ),
                          onChanged: (v) => idadeMax = int.tryParse(v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (grupoSel == null ||
                      quadraSel == null ||
                      dataSel == null ||
                      horaInicioSel == null ||
                      horaFimSel == null ||
                      nomeCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                        content: Text('Preencha os campos obrigatórios.'),
                      ),
                    );
                    return;
                  }

                  final esporteId = grupoSel!['fk_id_esporte'] as int;
                  final grupoId = grupoSel!['id'] as int;
                  final quadraId = quadraSel!['quadra_id'] as int;
                  final data = DateFormat('yyyy-MM-dd').format(dataSel!);

                  final evento = Evento(
                    nome: nomeCtrl.text.trim(),
                    descricao: descCtrl.text.trim(),
                    fkIdGrupoEsportes: grupoId,
                    fkIdEstabelecimento:
                        quadraSel!['estabelecimento_id'] as int,
                    fkIdCriador: userId,
                    fkIdEsporte: esporteId,
                    visibilidade: visibilidade,
                    idadeMin: idadeMin,
                    idadeMax: idadeMax,
                    genero: genero,
                    dataHoraInicio: '$data $horaInicioSel',
                    dataHoraFim: '$data $horaFimSel',
                    status: 'publico',
                  );

                  final eventoId = await repoEvento.create(evento);

                  await repoReserva.criarReserva(
                    eventoId: eventoId,
                    quadraId: quadraId,
                    data: data,
                    horaInicio: horaInicioSel!,
                    horaFim: horaFimSel!,
                  );

                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Evento criado com sucesso!')),
                  );
                  Navigator.pop(ctx);

                  Modular.to.navigate('/home/');
                },
                child: const Text('Criar evento'),
              ),
            ],
          );
        },
      ),
    );
  }
}
