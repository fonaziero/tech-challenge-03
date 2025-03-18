import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Usuário logado com sucesso: ${credential.user?.uid}');
      return credential.user;
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Usuário criado com sucesso: ${credential.user?.uid}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Erro ao criar usuário: ${e.message}');
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
