import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EventoCard extends StatelessWidget {
  final Map<String, dynamic> evento;

  const EventoCard({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        title: Text(
          evento['nome'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${evento['descricao'] ?? ''}\n'
          'Data: ${evento['data_hora_inicio']}',
        ),
        isThreeLine: true,
        onTap: () {
          Modular.to.pushNamed(
            '/evento_detalhes/',
            arguments: evento['id'],
          );
        },
      ),
    );
  }
}