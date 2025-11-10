import 'package:reserva_eventos/data/database/app_database.dart';
import 'package:reserva_eventos/data/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDAO {
  Future<int> insert(User user) async {
    final db = await AppDatabase.instance.database;
    return db.insert('usuarios', user.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<User?> login(String email, String senhaHash) async {
    final db = await AppDatabase.instance.database;
    final res = await db.query(
      'usuarios',
      where: 'email = ? AND senha_hash = ?',
      whereArgs: [email, senhaHash],
      limit: 1,
    );
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  Future<void> vincularEsportes(int userId, List<int> esportesIds) async {
    final db = await AppDatabase.instance.database;

    final batch = db.batch();

    for(final idEsporte in esportesIds){
      batch.insert('usuario_esportes', 
      {
        'fk_id_usuario': userId,
        'fk_id_esporte': idEsporte,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore
      );
    }
      await batch.commit(noResult: true);
  }

  Future<bool> participaDeAlgumGrupo(int userId) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'grupos_esportes_participantes',
      where: 'fk_id_usuario = ?',
      whereArgs: [userId],
      limit: 1,
    );

    return result.isNotEmpty;
  }
  
}
