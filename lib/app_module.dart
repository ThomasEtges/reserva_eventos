
import 'package:flutter_modular/flutter_modular.dart';
import 'package:reserva_eventos/data/database/app_database.dart';
import 'package:reserva_eventos/data/database/daos/evento_dao.dart';
import 'package:reserva_eventos/data/database/daos/user_dao.dart';
import 'package:reserva_eventos/data/repositories/evento_repository.dart';
import 'package:reserva_eventos/data/repositories/user_repository.dart';
import 'package:reserva_eventos/modules/cadastro/cadastro_module.dart';
import 'package:reserva_eventos/modules/grupo_eventos/grupo_esportes_module.dart';
import 'package:reserva_eventos/modules/home/home_module.dart';
import 'package:reserva_eventos/modules/login/login_module.dart';

class AppModule extends Module {

  @override
  void binds(i) {
    i.addInstance(AppDatabase.instance);

    i.addLazySingleton<UserDAO>(UserDAO.new);
    i.addLazySingleton<UserRepository>(() => UserRepository(i.get<UserDAO>()));
    i.addLazySingleton<EventoDAO>(EventoDAO.new);
    i.addLazySingleton<EventoRepository>(() => EventoRepository(i.get<EventoDAO>()));
    
  }

  @override
  void routes(RouteManager r) {
    r.redirect('/', to: '/login/');
    r.module('/login', module: LoginModule());
    r.module('/cadastro', module: CadastroModule());
    r.module('/home', module: HomeModule());
    r.module('/grupos_esportes', module: GrupoEsportesModule());
  }
}

