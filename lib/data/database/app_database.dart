import 'dart:async';
import 'package:path/path.dart';
//import 'package:reserva_eventos/data/database/seeds/seeds_data.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'reserva_eventos.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    
    await db.execute('''
      CREATE TABLE cidades (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE esportes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL UNIQUE
      );
    ''');

    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha_hash TEXT NOT NULL,
        genero TEXT NOT NULL,
        idade INTEGER NOT NULL,
        fk_id_cidade INTEGER NOT NULL,
        FOREIGN KEY (fk_id_cidade) REFERENCES cidades (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE usuario_esportes (
        fk_id_usuario INTEGER NOT NULL,
        fk_id_esporte INTEGER NOT NULL,
        PRIMARY KEY (fk_id_usuario, fk_id_esporte),
        FOREIGN KEY (fk_id_usuario) REFERENCES usuarios (id),
        FOREIGN KEY (fk_id_esporte) REFERENCES esportes (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE estabelecimentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        fk_id_cidade INTEGER NOT NULL,
        horario_inicio_funcionamento TEXT NOT NULL,
        horario_fim_funcionamento TEXT NOT NULL,
        FOREIGN KEY (fk_id_cidade) REFERENCES cidades (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE quadras (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        fk_id_estabelecimento INTEGER NOT NULL,
        fk_id_esporte INTEGER NOT NULL,
        FOREIGN KEY (fk_id_estabelecimento) REFERENCES estabelecimentos (id),
        FOREIGN KEY (fk_id_esporte) REFERENCES esportes (id),
        UNIQUE (fk_id_estabelecimento, nome)
      );
    ''');

    await db.execute('''
      CREATE TABLE quadra_horarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fk_id_quadra INTEGER NOT NULL,
        dia_semana INTEGER NOT NULL,
        hora_inicio TEXT NOT NULL,
        hora_fim TEXT NOT NULL, 
        disponivel INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (fk_id_quadra) REFERENCES quadras (id)
      );
    ''');
    
    await db.execute('''
      CREATE TABLE quadra_reservas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fk_id_evento INTEGER NOT NULL,
        fk_id_quadra INTEGER NOT NULL,
        data TEXT NOT NULL,     
        hora_inicio TEXT NOT NULL,
        hora_fim TEXT NOT NULL, 
        status TEXT NOT NULL DEFAULT 'reservado', 
        FOREIGN KEY (fk_id_evento) REFERENCES eventos (id),
        FOREIGN KEY (fk_id_quadra) REFERENCES quadras (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE grupos_esportes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        fk_id_esporte INTEGER NOT NULL,
        fk_id_cidade INTEGER NOT NULL,
        fk_id_criador INTEGER NOT NULL,
        descricao TEXT NOT NULL,
        visibilidade TEXT NOT NULL,
        FOREIGN KEY (fk_id_esporte) REFERENCES esportes (id),
        FOREIGN KEY (fk_id_cidade) REFERENCES cidades (id),
        FOREIGN KEY (fk_id_criador) REFERENCES usuarios (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE grupos_esportes_participantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fk_id_grupo_esportes INTEGER NOT NULL,
        fk_id_usuario INTEGER NOT NULL,
        papel TEXT NOT NULL,
        FOREIGN KEY (fk_id_grupo_esportes) REFERENCES grupos_esportes (id),
        FOREIGN KEY (fk_id_usuario) REFERENCES usuarios (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE grupos_usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        fk_id_criador INTEGER NOT NULL,
        descricao TEXT NOT NULL,
        visibilidade TEXT NOT NULL,
        FOREIGN KEY (fk_id_criador) REFERENCES usuarios (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE grupos_usuarios_participantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fk_id_grupo_usuarios INTEGER NOT NULL,
        fk_id_usuario INTEGER NOT NULL,
        papel TEXT NOT NULL,
        FOREIGN KEY (fk_id_grupo_usuarios) REFERENCES grupos_usuarios (id),
        FOREIGN KEY (fk_id_usuario) REFERENCES usuarios (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE eventos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT NOT NULL,
        fk_id_grupo_esportes INTEGER NOT NULL,
        fk_id_estabelecimento INTEGER NOT NULL,
        fk_id_criador INTEGER NOT NULL,
        fk_id_esporte INTEGER NOT NULL,
        visibilidade TEXT NOT NULL,
        idade_min INTEGER,
        idade_max INTEGER,
        genero TEXT,
        data_hora_inicio TEXT NOT NULL,
        data_hora_fim TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (fk_id_grupo_esportes) REFERENCES grupos_esportes (id),
        FOREIGN KEY (fk_id_estabelecimento) REFERENCES estabelecimentos (id),
        FOREIGN KEY (fk_id_criador) REFERENCES usuarios (id),
        FOREIGN KEY (fk_id_esporte) REFERENCES esportes (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE eventos_participantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fk_id_evento INTEGER NOT NULL,
        fk_id_usuario INTEGER NOT NULL,
        papel TEXT NOT NULL,
        FOREIGN KEY (fk_id_evento) REFERENCES eventos (id),
        FOREIGN KEY (fk_id_usuario) REFERENCES usuarios (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE pedidos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fk_id_usuario INTEGER NOT NULL,
        fk_id_origem_pedido INTEGER NOT NULL,
        fk_id_destinatario INTEGER NOT NULL,
        origem_pedido TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (fk_id_origem_pedido) REFERENCES usuarios (id),
        FOREIGN KEY (fk_id_usuario) REFERENCES usuarios (id),
        FOREIGN KEY (fk_id_destinatario) REFERENCES usuarios (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE notificacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fk_id_usuario INTEGER NOT NULL,
        mensagem TEXT NOT NULL,
        lida INTEGER NOT NULL CHECK (lida IN (0,1)),
        FOREIGN KEY (fk_id_usuario) REFERENCES usuarios (id)
      );
    ''');

    //await SeedData.populate(db);

  }

  Future<void> close() async {
    final db = _db;
    if (db != null && db.isOpen) {
      await db.close();
      _db = null;
    }
  }
}
