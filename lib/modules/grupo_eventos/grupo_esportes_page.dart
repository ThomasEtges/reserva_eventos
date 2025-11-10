import 'package:flutter/material.dart';
import 'grupo_esportes_controller.dart';
import 'package:reserva_eventos/widgets/grupo_esportes_card.dart';

class GrupoEsportesPage extends StatefulWidget {
  const GrupoEsportesPage({super.key});

  @override
  State<GrupoEsportesPage> createState() => _GrupoEsportesPageState();
}

class _GrupoEsportesPageState extends State<GrupoEsportesPage> {
  final controller = GrupoEsportesController();
  List<Map<String, dynamic>> grupos = [];

  @override
  void initState() {
    super.initState();
    loadGrupos();
  }

  Future<void> loadGrupos() async {
    final lista = await controller.listarGrupos();
    setState(() {
      grupos = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupos de Esportes'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadGrupos),
        ],
      ),

      body: grupos.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Nenhum grupo disponível no momento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
          : ListView.builder(
              itemCount: grupos.length,
              itemBuilder: (context, index) {
                final grupo = grupos[index];

                return GrupoEsportesCard(
                  grupoEsporte: grupo,
                  onParticiparOuSair: () async {
                    final participa = (grupo['participa'] ?? 0) == 1;
                    await controller.alternarParticipacao(
                      grupo['id'],
                      participa,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          participa
                              ? 'Você saiu de ${grupo['nome']}!'
                              : 'Você entrou em ${grupo['nome']}!',
                        ),
                      ),
                    );

                    await loadGrupos();
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.criarGrupoEsporteDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('CRIAR GRUPO'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
