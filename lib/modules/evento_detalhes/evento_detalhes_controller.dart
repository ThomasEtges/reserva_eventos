import 'package:flutter/material.dart';
import 'package:reserva_eventos/data/database/daos/notificacao_dao.dart';
import 'package:reserva_eventos/data/repositories/notificacao_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:reserva_eventos/data/database/daos/evento_detalhes_dao.dart';
import 'package:reserva_eventos/data/repositories/evento_detalhes_repository.dart';

import 'package:reserva_eventos/data/database/daos/pedido_dao.dart';
import 'package:reserva_eventos/data/repositories/pedido_repository.dart';

import 'package:reserva_eventos/data/database/daos/evento_participante_dao.dart';
import 'package:reserva_eventos/data/repositories/evento_participante_repository.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:reserva_eventos/data/repositories/evento_repository.dart';
import 'package:reserva_eventos/data/database/daos/evento_dao.dart';

class EventoDetalhesController {
  final repoDetalhes = EventoDetalhesRepository(EventoDetalhesDAO());
  final repoPedido = PedidoRepository(PedidoDAO());
  final repoParticipante = EventoParticipanteRepository(
    EventoParticipanteDAO(),
  );
  final repoEvento = EventoRepository(EventoDAO());
  final notifRepo = NotificacaoRepository(NotificacaoDAO());

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<Map<String, dynamic>?> carregarEvento(int eventoId) =>
      repoDetalhes.buscarPorId(eventoId);

  Future<List<Map<String, dynamic>>> carregarParticipantes(int eventoId) =>
      repoDetalhes.listarParticipantes(eventoId);

  Future<void> excluirEvento(BuildContext context, int eventoId) async {
    try {
      final userId = await _getUserId();

      final participantes = await repoDetalhes.listarParticipantes(eventoId);
      final dados = await repoDetalhes.buscarPorId(eventoId);
      final nomeEvento = dados?['evento_nome'];

      await repoDetalhes.excluirEvento(eventoId);

      for (final p in participantes) {
        final pid = p['id'] as int;
        if (pid != userId) {
          await notifRepo.criar(pid, 'O evento "$nomeEvento" foi cancelado.');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento excluído com sucesso!')),
      );
      Modular.to.navigate('/home/');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir evento: $e')));
    }
  }

  Future<void> participarDoEventoPublico(
    BuildContext context, {
    required int eventoId,
  }) async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não identificado.')),
        );
        return;
      }

      final ja = await repoParticipante.jaParticipa(userId, eventoId);
      if (ja) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você já participa deste evento.')),
        );
        return;
      }

      await repoParticipante.adicionarParticipante(userId, eventoId);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Participação confirmada!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao participar: $e')));
      print(e);
    }
  }

  Future<void> pedirParaParticiparPrivado(
    BuildContext context, {
    required int eventoId,
    required int fkIdCriador,
  }) async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não identificado.')),
        );
        return;
      }

      final existe = await repoPedido.existePedidoEvento(userId, eventoId);
      if (existe) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido já enviado para este evento.')),
        );
        return;
      }

      await repoPedido.criarPedidoEvento(userId, eventoId, fkIdCriador);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido enviado ao criador do evento!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao enviar pedido: $e')));
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> carregarPedidosDoEvento(
    int eventoId,
  ) async {
    final userId = await _getUserId();
    if (userId == null) return [];
    return repoPedido.listarPedidosEvento(eventoId, userId);
  }

  Future<void> aceitarPedido(
    BuildContext context, {
    required int pedidoId,
    required int eventoId,
    required int usuarioId,
  }) async {
    try {
      await repoParticipante.adicionarParticipante(usuarioId, eventoId);
      await repoPedido.excluirPedido(pedidoId);

      await notifRepo.criar(
        usuarioId,
        'Seu pedido foi aceito! Você agora participa do evento.',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido aceito! Participante adicionado.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao aceitar pedido: $e')));
    }
  }

  Future<void> recusarPedido(
    BuildContext context, {
    required int pedidoId,
    required int usuarioId,
  }) async {
    try {
      await repoPedido.excluirPedido(pedidoId);
      await notifRepo.criar(usuarioId, 'Seu pedido foi recusado.');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pedido recusado.')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao recusar pedido: $e')));
    }
  }
}
