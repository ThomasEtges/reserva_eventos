import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

class SeedData {
  static Future<void> populate(Database db) async {
    final batch = db.batch();

    //cidades

    batch.insert('cidades', {'nome': 'Santa Cruz do Sul'}); //id 1
    batch.insert('cidades', {'nome': 'Venâncio Aires'}); //id 2
    batch.insert('cidades', {'nome': 'Lajeado'}); //id 3
    batch.insert('cidades', {'nome': 'Porto Alegre'}); //id 4
    batch.insert('cidades', {'nome': 'Estrela'}); //id 5

    //esportes

    batch.insert('esportes', {'nome': 'Futebol'}); //id 1
    batch.insert('esportes', {'nome': 'Vôlei'}); //id 2
    batch.insert('esportes', {'nome': 'Basquete'}); //id 3
    batch.insert('esportes', {'nome': 'Tênis'}); //id 4
    batch.insert('esportes', {'nome': 'Padel'}); //id 5
    batch.insert('esportes', {'nome': 'Futsal'}); //id 6
    batch.insert('esportes', {'nome': 'Handebol'}); //id 7
    batch.insert('esportes', {'nome': 'Beach Tennis'}); //id 8

    // estabelecimentos

    batch.insert('estabelecimentos', {
      //id 1
      'nome': 'Arena Central',
      'fk_id_cidade': 1,
      'horario_inicio_funcionamento': '07:00',
      'horario_fim_funcionamento': '22:00',
    });
    batch.insert('estabelecimentos', {
      //id 2
      'nome': 'Clube Esportivo União',
      'fk_id_cidade': 2,
      'horario_inicio_funcionamento': '08:00',
      'horario_fim_funcionamento': '23:00',
    });
    batch.insert('estabelecimentos', {
      //id 3
      'nome': 'Quadras Beira Rio',
      'fk_id_cidade': 1,
      'horario_inicio_funcionamento': '09:00',
      'horario_fim_funcionamento': '21:00',
    });
    batch.insert('estabelecimentos', {
      //id 4
      'nome': 'Centro de Esportes Vale',
      'fk_id_cidade': 3,
      'horario_inicio_funcionamento': '07:30',
      'horario_fim_funcionamento': '22:30',
    });
    batch.insert('estabelecimentos', {
      //id 5
      'nome': 'Arena Nova Onda',
      'fk_id_cidade': 4,
      'horario_inicio_funcionamento': '06:00',
      'horario_fim_funcionamento': '23:59',
    });

    //quadras

    batch.insert('quadras', {
      //id 1
      'nome': 'Quadra A',
      'fk_id_estabelecimento': 1,
      'fk_id_esporte': 3,
    });
    batch.insert('quadras', {
      //id 2
      'nome': 'Quadra B',
      'fk_id_estabelecimento': 1,
      'fk_id_esporte': 2,
    });
    batch.insert('quadras', {
      //id 3
      'nome': 'Campo 1',
      'fk_id_estabelecimento': 2,
      'fk_id_esporte': 1,
    });
    batch.insert('quadras', {
      //id 4
      'nome': 'Campo 2',
      'fk_id_estabelecimento': 2,
      'fk_id_esporte': 6,
    });
    batch.insert('quadras', {
      //id 5
      'nome': 'Quadra Tênis 1',
      'fk_id_estabelecimento': 3,
      'fk_id_esporte': 4,
    });
    batch.insert('quadras', {
      //id 6
      'nome': 'Quadra Padel 1',
      'fk_id_estabelecimento': 3,
      'fk_id_esporte': 5,
    });
    batch.insert('quadras', {
      //id 7
      'nome': 'Campo Arena Vale',
      'fk_id_estabelecimento': 4,
      'fk_id_esporte': 1,
    });
    batch.insert('quadras', {
      //id 8
      'nome': 'Ginásio 1',
      'fk_id_estabelecimento': 5,
      'fk_id_esporte': 7,
    });
    batch.insert('quadras', {
      //id 9
      'nome': 'Campo de Futebol',
      'fk_id_estabelecimento': 1,
      'fk_id_esporte': 1,
    });

    final senhaAdmin = 'admin123';
    final senhaHash = sha256.convert(utf8.encode(senhaAdmin)).toString();

    batch.insert('usuarios', {
      'nome': 'Administrador',
      'email': 'admin@reservaeventos.com',
      'senha_hash': senhaHash,
      'genero': 'Outro',
      'idade': 25,
      'fk_id_cidade': 1,
    });

    batch.insert('grupos_esportes', {
      'nome': 'Futebol Santa Cruz do Sul',
      'fk_id_esporte': 1,
      'fk_id_cidade': 1,
      'fk_id_criador': 1,
      'descricao': 'Grupo padrão de futebol em Santa Cruz do Sul.',
      'visibilidade': 'publico',
    });

    batch.insert('grupos_esportes_participantes', {
      'fk_id_grupo_esportes': 1,
      'fk_id_usuario': 1,
      'papel': 'criador',
    });

    batch.insert('eventos', {
      'nome': 'Pelada de Sábado',
      'descricao': 'Jogo amistoso de futebol aberto para moradores da cidade.',
      'fk_id_grupo_esportes': 1,
      'fk_id_estabelecimento': 1,
      'fk_id_criador': 1,
      'fk_id_esporte': 1,
      'visibilidade': 'publico',
      'idade_min': 16,
      'idade_max': 40,
      'genero': 'misto',
      'data_hora_inicio': '2025-11-15 17:00',
      'data_hora_fim': '2025-11-15 19:00',
      'status': 'publico',
    });

    batch.insert('eventos', {
      'nome': 'Treino de Futebol das Quartas',
      'descricao': 'Treino recreativo semanal no campo principal.',
      'fk_id_grupo_esportes': 1,
      'fk_id_estabelecimento': 2,
      'fk_id_criador': 1,
      'fk_id_esporte': 1,
      'visibilidade': 'publico',
      'idade_min': 18,
      'idade_max': 35,
      'genero': 'masculino',
      'data_hora_inicio': '2025-11-13 20:00',
      'data_hora_fim': '2025-11-13 22:00',
      'status': 'publico',
    });

    batch.insert('eventos', {
      'nome': 'Domingão da Bola',
      'descricao': 'Partida tradicional de domingo com churrasco após o jogo.',
      'fk_id_grupo_esportes': 1,
      'fk_id_estabelecimento': 3,
      'fk_id_criador': 1,
      'fk_id_esporte': 1,
      'visibilidade': 'publico',
      'idade_min': 20,
      'idade_max': 50,
      'genero': 'misto',
      'data_hora_inicio': '2025-11-16 09:00',
      'data_hora_fim': '2025-11-16 11:00',
      'status': 'publico',
    });

    batch.insert('eventos', {
      'nome': 'Futebol das Amigas',
      'descricao': 'Partida feminina de futebol para integração e diversão.',
      'fk_id_grupo_esportes': 1,
      'fk_id_estabelecimento': 1,
      'fk_id_criador': 1,
      'fk_id_esporte': 1,
      'visibilidade': 'privado',
      'idade_min': 14,
      'idade_max': 45,
      'genero': 'feminino',
      'data_hora_inicio': '2025-11-20 18:30',
      'data_hora_fim': '2025-11-20 20:30',
      'status': 'publico',
    });

    // Quadra A (Basquete)
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 1,
      'dia_semana': 1,
      'hora_inicio': '19:00',
      'hora_fim': '20:00',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 1,
      'dia_semana': 3,
      'hora_inicio': '19:00',
      'hora_fim': '20:00',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 1,
      'dia_semana': 5,
      'hora_inicio': '19:00',
      'hora_fim': '20:00',
    });

    // Quadra B (Vôlei)
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 2,
      'dia_semana': 2,
      'hora_inicio': '18:30',
      'hora_fim': '19:30',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 2,
      'dia_semana': 4,
      'hora_inicio': '18:30',
      'hora_fim': '19:30',
    });

    // Campo 1 (Futebol)
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 3,
      'dia_semana': 2,
      'hora_inicio': '18:00',
      'hora_fim': '20:00',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 3,
      'dia_semana': 4,
      'hora_inicio': '18:00',
      'hora_fim': '20:00',
    });

    // Campo 2 (Futsal)
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 4,
      'dia_semana': 3,
      'hora_inicio': '19:30',
      'hora_fim': '21:00',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 4,
      'dia_semana': 6,
      'hora_inicio': '10:00',
      'hora_fim': '12:00',
    });

    // Quadra Tênis 1
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 5,
      'dia_semana': 1,
      'hora_inicio': '08:00',
      'hora_fim': '09:00',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 5,
      'dia_semana': 3,
      'hora_inicio': '08:00',
      'hora_fim': '09:00',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 5,
      'dia_semana': 5,
      'hora_inicio': '08:00',
      'hora_fim': '09:00',
    });

    // Quadra Padel 1
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 6,
      'dia_semana': 2,
      'hora_inicio': '18:00',
      'hora_fim': '19:00',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 6,
      'dia_semana': 4,
      'hora_inicio': '18:00',
      'hora_fim': '19:00',
    });

    // Campo Arena Vale
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 7,
      'dia_semana': 1,
      'hora_inicio': '20:00',
      'hora_fim': '21:30',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 7,
      'dia_semana': 5,
      'hora_inicio': '20:00',
      'hora_fim': '21:30',
    });

    // Ginásio 1 (Handebol)
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 8,
      'dia_semana': 2,
      'hora_inicio': '19:00',
      'hora_fim': '20:30',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 8,
      'dia_semana': 4,
      'hora_inicio': '19:00',
      'hora_fim': '20:30',
    });

    // Campo de Futebol
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 9,
      'dia_semana': 1,
      'hora_inicio': '18:00',
      'hora_fim': '20:00',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 9,
      'dia_semana': 3,
      'hora_inicio': '18:00',
      'hora_fim': '20:00',
    });
    batch.insert('quadra_horarios', {
      'fk_id_quadra': 9,
      'dia_semana': 5,
      'hora_inicio': '18:00',
      'hora_fim': '20:00',
    });

    await batch.commit(noResult: true);

    print('banco populado');
  }
}
