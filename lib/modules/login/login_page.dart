import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:reserva_eventos/modules/login/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = LoginController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Reserva de Eventos', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
                hintText: "Digite seu email",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Senha",
                hintText: "Digite sua senha",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.login(
                context,
                emailController.text,
                senhaController.text,
              ),
              child: const Text('Entrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Modular.to.navigate('/cadastro/');
              },
              child: const Text('Ir para cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}
