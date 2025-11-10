import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'grupo_esportes_controller.dart';

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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadGrupos,
          ),
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
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      grupo['nome'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(grupo['descricao'] ?? ''),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await controller.participar(grupo['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Você entrou em ${grupo['nome']}!'),
                          ),
                        );
                        Modular.to.navigate('/home/');
                      },
                      child: const Text('Participar'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
