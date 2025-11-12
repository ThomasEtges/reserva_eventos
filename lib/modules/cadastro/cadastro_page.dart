import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:reserva_eventos/modules/cadastro/cadastro_controller.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final controller = CadastroController();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final generoController = TextEditingController();
  final idadeController = TextEditingController();

  int? cidadeSelecionada;
  String? generoSelecionado;
  List<String> generos = ['Masculino', 'Feminino', 'Outro'];
  List<Map<String, dynamic>> cidades = [];
  List<Map<String, dynamic>> esportes = [];
  List<int> esportesSelecionados = [];

  @override
  void initState() {
    super.initState();
    _carregarCidades();
    _carregarEsportes();
  }

  Future<void> _carregarCidades() async {
    final lista = await controller.carregarCidades();
    setState(() => cidades = lista);
  }

  Future<void> _carregarEsportes() async {
    final lista = await controller.carregarEsportes();
    setState(() => esportes = lista);
  }

  void _onCadastrar() {
    controller.cadastroUsuario(
      context: context,
      nome: nomeController.text,
      email: emailController.text,
      senha: senhaController.text,
      genero: generoSelecionado ?? '',
      idade: int.tryParse(idadeController.text) ?? 0,
      fkIdCidade: cidadeSelecionada ?? 0,
      esportesSelecionados: esportesSelecionados,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Cadastro', style: TextStyle(fontSize: 22)),
              const SizedBox(height: 30),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
                value: cidadeSelecionada,
                items: cidades.map((cidade) {
                  return DropdownMenuItem<int>(
                    value: cidade['id'],
                    child: Text(cidade['nome']),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() => cidadeSelecionada = valor);
                },
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gênero',
                  border: OutlineInputBorder(),
                ),
                value: generoSelecionado,
                items: generos.map((genero) {
                  return DropdownMenuItem<String>(
                    value: genero,
                    child: Text(genero),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() => generoSelecionado = valor);
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Esportes favoritos',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: esportes
                      .where((e) => esportesSelecionados.contains(e['id']))
                      .map((e) => e['nome'])
                      .join(', '),
                ),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setStateDialog) {
                          return AlertDialog(
                            title: const Text(
                              'Selecione seus esportes favoritos',
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: esportes.map((esporte) {
                                  final id = esporte['id'] as int;
                                  final nome = esporte['nome'] as String;
                                  final selecionado = esportesSelecionados
                                      .contains(id);

                                  return CheckboxListTile(
                                    title: Text(nome),
                                    value: selecionado,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    onChanged: (marcado) {
                                      setStateDialog(() {
                                        if (marcado == true) {
                                          esportesSelecionados.add(id);
                                        } else {
                                          esportesSelecionados.remove(id);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Fechar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onCadastrar,
                child: const Text('Fazer cadastro'),
              ),
              ElevatedButton(
                onPressed: () {
                  Modular.to.navigate('/login/');
                },
                child: const Text('Ir para login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
