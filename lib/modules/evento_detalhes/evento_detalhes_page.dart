import 'package:flutter/material.dart';
import 'package:reserva_eventos/modules/evento_detalhes/evento_detalhes_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class EventoDetalhesPage extends StatefulWidget {
  final int eventoId;
  const EventoDetalhesPage({super.key, required this.eventoId});

  @override
  State<EventoDetalhesPage> createState() => _EventoDetalhesPageState();
  
}

class _EventoDetalhesPageState extends State<EventoDetalhesPage> {
  final controller = EventoDetalhesController();
  Map<String, dynamic>? evento;
  List<Map<String, dynamic>> participantes = [];
  int? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarTudo();
  }

  Future<void> _abrirPedidosBottomSheet(BuildContext context) async {
  final pedidos = await controller.carregarPedidosDoEvento(widget.eventoId);

  if (pedidos.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nenhum pedido pendente.')),
    );
    return;
  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pedidos pendentes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ...pedidos.map((p) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(p['usuario_nome']),
                  subtitle: Text('Status: ${p['status']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          await controller.recusarPedido(
                            context,
                            pedidoId: p['pedido_id'],
                          );
                          Navigator.pop(ctx);
                          await _abrirPedidosBottomSheet(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          await controller.aceitarPedido(
                            context,
                            pedidoId: p['pedido_id'],
                            eventoId: widget.eventoId,
                            usuarioId: p['usuario_id'],
                          );
                          Navigator.pop(ctx);
                          await _abrirPedidosBottomSheet(context);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}


  Future<void> _carregarTudo() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    final e = await controller.carregarEvento(widget.eventoId);
    final p = await controller.carregarParticipantes(widget.eventoId);

    setState(() {
      evento = e;
      participantes = p;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (evento == null) {
      return const Scaffold(
        body: Center(child: Text('Evento não encontrado.')),
      );
    }

    final df = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(evento!['evento_nome'] ?? 'Detalhes do Evento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evento!['descricao'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Divider(),
            _info('Esporte', evento!['esporte_nome']),
            _info('Quadra', evento!['quadra_nome']),
            _info('Local', evento!['estabelecimento_nome']),
            _info('Gênero', evento!['genero']),
            _info('Visibilidade', evento!['visibilidade']),
            _info(
              'Data/Hora',
              '${df.format(DateTime.parse(evento!['data_hora_inicio']))} - ${df.format(DateTime.parse(evento!['data_hora_fim']))}',
            ),
            if (evento!['idade_min'] != null || evento!['idade_max'] != null)
              _info(
                'Faixa etária',
                '${evento!['idade_min'] ?? 'X'} a ${evento!['idade_max'] ?? 'X'} anos',
              ),
            Divider(),
            const SizedBox(height: 8),
            const Text(
              'Participantes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),
            ...participantes.map(
              (p) => ListTile(
                leading: const Icon(Icons.person),
                title: Text(p['nome']),
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 24),

Builder(builder: (context) {
  final ehCriador = evento!['fk_id_criador'] == userId;
  final visibilidade = (evento!['visibilidade'] ?? 'publico') as String;
  final fkIdCriador = evento!['fk_id_criador'] as int;

  if (ehCriador) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            await _abrirPedidosBottomSheet(context);
          },
          icon: const Icon(Icons.list_alt),
          label: const Text('Ver pedidos'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 132, 148, 235),
            minimumSize: const Size.fromHeight(45),
          ),
        ),
        const SizedBox(height: 8),

        ElevatedButton.icon(
          onPressed: () async {
            final confirmar = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Excluir evento'),
                content: const Text(
                    'Tem certeza que deseja excluir este evento? Esta ação é permanente.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Excluir'),
                  ),
                ],
              ),
            );

            if (confirmar == true) {
              await controller.excluirEvento(context, widget.eventoId);
            }
          },
          icon: const Icon(Icons.delete_forever),
          label: const Text('Excluir evento'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size.fromHeight(45),
          ),
        ),
      ],
    );
  }

  if (visibilidade == 'publico') {
    return ElevatedButton.icon(
      onPressed: () async {
        await controller.participarDoEventoPublico(
          context,
          eventoId: widget.eventoId,
        );
        await _carregarTudo();
      },
      icon: const Icon(Icons.event_available),
      label: const Text('Participar do evento'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: const Size.fromHeight(45),
      ),
    );
  } else {
    return ElevatedButton.icon(
      onPressed: () async {
        await controller.pedirParaParticiparPrivado(
          context,
          eventoId: widget.eventoId,
          fkIdCriador: fkIdCriador,
        );
      },
      icon: const Icon(Icons.mail_outline),
      label: const Text('Pedir para participar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        minimumSize: const Size.fromHeight(45),
      ),
    );
  }
}),

          ],
        ),
      ),
    );
  }

  Widget _info(String label, String? value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(flex: 3, child: Text(value ?? '-')),
      ],
    ),
  );
}
