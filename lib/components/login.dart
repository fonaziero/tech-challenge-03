import 'package:bytebank/screens/home_page.dart';
import 'package:bytebank/services/auth/signIn.dart';
import 'package:flutter/material.dart';

const Color kBlack = Color(0xFF000000);
const Color kWhite = Color(0xFFFFFFFF);
const Color kGraw = Color(0xFF767676);
const Color kOrange = Color(0xFFFF5036);
const Color kGreen = Color(0xFF47A138);

class LoginDialog extends StatefulWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

void _doSignIn(String email, String password) async {
  try {
    await AuthService().signIn(email, password);
    
    Navigator.pop(context);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login efetuado com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao fazer login: $e')),
    );
  }
}


  @override
  void dispose() {
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
                  '../assets/images/login.png',
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 16),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Esqueci a senha!',
                      style: TextStyle(color: kGreen),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kOrange,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      final email = _emailController.text;
                      final senha = _senhaController.text;

                      if (email.isNotEmpty && senha.isNotEmpty) {
                        _doSignIn(email, senha);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Preencha todos os campos!')),
                        );
                      }
                    },
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
