import 'package:reserva_eventos/data/database/app_database.dart';

class CidadeDAO {
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await AppDatabase.instance.database;
    return await db.query('cidades', orderBy: 'nome ASC');
  }
}