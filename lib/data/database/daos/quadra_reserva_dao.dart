import 'package:reserva_eventos/data/database/app_database.dart';

class QuadraReservaDAO {
  Future<int> criarReserva({
    required int eventoId,
    required int quadraId,
    required String data,  
    required String horaInicio, 
    required String horaFim,
  }) async {
    final db = await AppDatabase.instance.database;
    return db.insert('quadra_reservas', {
      'fk_id_evento': eventoId,
      'fk_id_quadra': quadraId,
      'data': data,
      'hora_inicio': horaInicio,
      'hora_fim': horaFim,
      'status': 'reservado',
    });
  }
}
