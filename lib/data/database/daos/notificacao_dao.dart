import 'package:reserva_eventos/data/database/app_database.dart';

class NotificacaoDAO {
  Future<int> criar({required int usuarioId, required String mensagem}) async {
    final db = await AppDatabase.instance.database;
    return db.insert('notificacoes', {
      'fk_id_usuario': usuarioId,
      'mensagem': mensagem,
      'lida': 0,
    });
  }

  Future<List<Map<String, dynamic>>> listar(int usuarioId) async {
    final db = await AppDatabase.instance.database;
    return db.query(
      'notificacoes',
      where: 'fk_id_usuario = ?',
      whereArgs: [usuarioId],
      orderBy: 'id DESC',
    );
  }

  Future<void> marcarComoLida(int id) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'notificacoes',
      {'lida': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> excluirTodas(int usuarioId) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'notificacoes',
      where: 'fk_id_usuario = ?',
      whereArgs: [usuarioId],
    );
  }
}
