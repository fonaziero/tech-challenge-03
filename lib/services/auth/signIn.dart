import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Login OK: ${credential.user?.uid}');
      return credential.user;
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Cadastro OK: ${credential.user?.uid}');
      return credential.user;
    } catch (e) {
      print('Erro no cadastro: $e');
      return null;
    }
  }
}
