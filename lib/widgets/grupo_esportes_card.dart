import 'package:flutter/material.dart';

class GrupoEsportesCard extends StatelessWidget {
  final Map<String, dynamic> grupoEsporte;
  final VoidCallback onParticiparOuSair;

  const GrupoEsportesCard({
    super.key,
    required this.grupoEsporte,
    required this.onParticiparOuSair,
  });

  @override
  Widget build(BuildContext context) {
    final nome = grupoEsporte['nome'];
    final descricao = grupoEsporte['descricao'];
    final visibilidade = grupoEsporte['visibilidade'];
    final participa = (grupoEsporte['participa'] ?? 0) == 1;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          nome,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          '$descricao\nVisibilidade: $visibilidade',
          style: const TextStyle(height: 1.5),
        ),
        trailing: ElevatedButton(
          onPressed: onParticiparOuSair,
          style: ElevatedButton.styleFrom(
            backgroundColor: participa ? Colors.red : Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            participa ? 'Sair do grupo' : 'Participar',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
