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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId != null) {
      eventos = await controller.buscarEventos(userId!);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos disponíveis'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventos.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Nenhum evento disponível.\nParticipe de grupos para ver mais eventos!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              : Column(
                children: [
                  IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarEventos,
          ),
                  ListView.builder(
                      itemCount: eventos.length,
                      itemBuilder: (context, index) {
                        return EventoCard(evento: eventos[index]);
                      },
                    ),
                ],
              ),
                floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton.extended(
            heroTag: 'btn_grupos',
            backgroundColor: const Color.fromARGB(255, 69, 90, 100),
            icon: const Icon(Icons.home, color: Colors.white),
            label: const Text('Grupos Eventos', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Modular.to.navigate('/grupos_esportes/');
            },
          ),
          FloatingActionButton.extended(
            heroTag: 'btn_criar_evento',
            backgroundColor: Colors.deepPurple,
            icon: const Icon(Icons.add, color: Colors.white),
            label:
                const Text('Criar Evento', style: TextStyle(color: Colors.white)),
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

