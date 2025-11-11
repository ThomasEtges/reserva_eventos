import 'package:flutter_modular/flutter_modular.dart';
import 'package:reserva_eventos/modules/evento_detalhes/evento_detalhes_page.dart';

class EventoDetalhesModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) {
        final eventoId = Modular.args.data as int;
        return EventoDetalhesPage(eventoId: eventoId);
      },
    );
  }
}
