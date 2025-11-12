import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:reserva_eventos/modules/home/home_controller.dart';
import 'package:reserva_eventos/widgets/event_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();
  List<Map<String, dynamic>> eventos = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId != null) {
      final novosEventos = await controller.buscarEventos(userId!);
      setState(() {
        eventos = novosEventos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos disponíveis'),
        actions: [
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final uid = prefs.getInt('user_id');
              if (uid == null) return;

              final notificacoes = await controller.listarNotificacoes(uid);
              if (notificacoes.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nenhuma notificação.')),
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
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Notificações',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () async {
                                  await controller.limparNotificacoes(uid);
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Notificações limpas.'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete_forever),
                                label: const Text('Limpar'),
                              ),
                            ],
                          ),
                          const Divider(),
                          ...notificacoes.map((n) {
                            final lida = (n['lida'] as int) == 1;
                            return ListTile(
                              leading: Icon(
                                lida
                                    ? Icons.mark_email_read
                                    : Icons.notifications,
                                color: lida ? Colors.grey : Colors.deepPurple,
                              ),
                              title: Text(n['mensagem']),
                              onTap: () async {
                                await controller.marcarComoLida(n['id'] as int);
                                Navigator.pop(ctx);
                              },
                            );
                          }),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.notifications),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 206, 178, 255),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _carregarEventos,
                icon: const Icon(Icons.refresh),
                label: const Text('Atualizar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 206, 178, 255),
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (eventos.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'Nenhum evento disponível.\nParticipe de grupos para ver mais eventos!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: eventos.length,
                  itemBuilder: (context, index) {
                    return EventoCard(evento: eventos[index]);
                  },
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton.extended(
            heroTag: 'btn_grupos',
            backgroundColor: const Color.fromARGB(255, 69, 90, 100),
            icon: const Icon(Icons.home, color: Colors.white),
            label: const Text(
              'Grupos Eventos',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Modular.to.navigate('/grupos_esportes/');
            },
          ),
          FloatingActionButton.extended(
            heroTag: 'btn_criar_evento',
            backgroundColor: Colors.deepPurple,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Criar Evento',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await controller.abrirCriarEventoDialog(context);
              await _carregarEventos();
            },
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
