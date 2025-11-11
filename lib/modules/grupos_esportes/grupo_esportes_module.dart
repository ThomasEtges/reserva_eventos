import 'package:flutter_modular/flutter_modular.dart';
import 'grupo_esportes_page.dart';

class GrupoEsportesModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const GrupoEsportesPage());
  }
}
