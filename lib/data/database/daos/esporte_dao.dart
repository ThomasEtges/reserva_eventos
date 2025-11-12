import 'package:reserva_eventos/data/database/app_database.dart';

class EsporteDao {
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await AppDatabase.instance.database;
    return await db.query('esportes', orderBy: 'nome ASC');
  }
}
  