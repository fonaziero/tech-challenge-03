import 'package:bytebank/screens/home_page.dart';
import 'package:bytebank/services/auth/signUp.dart';
import 'package:flutter/material.dart';

const Color kBlack = Color(0xFF000000);
const Color kWhite = Color(0xFFFFFFFF);
const Color kGraw = Color(0xFF767676);
const Color kOrange = Color(0xFFFF5036);

class AbrirContaDialog extends StatefulWidget {
  const AbrirContaDialog({Key? key}) : super(key: key);

  @override
  _AbrirContaDialogState createState() => _AbrirContaDialogState();
}

class _AbrirContaDialogState extends State<AbrirContaDialog> {
  bool _termosAceitos = false;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final authService = AuthService();

void _doSignUp(String nome, String email, String password) async {
  try {
    await authService.signUp(email, password);

    Navigator.pop(context);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Conta criada com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao criar conta: $e')),
    );
  }
}


  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Image.asset(
                  '../assets/images/cadastro.png',
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 16),
                Text(
                  'Preencha os campos abaixo para criar sua conta corrente!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    hintText: 'Digite seu nome completo',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Digite seu email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Li e estou de acordo com a Política de Privacidade',
                    style: TextStyle(color: kGraw),
                  ),
                  value: _termosAceitos,
                  onChanged: (bool? value) {
                    setState(() {
                      _termosAceitos = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kOrange,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _termosAceitos
                        ? () async {
                            final nome = _nomeController.text;
                            final email = _emailController.text;
                            final senha = _senhaController.text;

                            if (nome.isNotEmpty && email.isNotEmpty && senha.isNotEmpty) {
                              _doSignUp(nome, email, senha);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Preencha todos os campos!')),
                              );
                            }
                          }
                        : null,
                    child: Text(
                      'Criar conta',
                      style: TextStyle(color: kWhite, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
