import 'package:flutter_modular/flutter_modular.dart';
import 'cadastro_page.dart';

class CadastroModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const CadastroPage());
  }
}
