import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Iniciar sesión con email y contraseña
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Error en inicio de sesión: $e");
      rethrow;
    }
  }

  // Registrar usuario con email y contraseña
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Error en registro: $e");
      rethrow;
    }
  }

  // Restablecer contraseña
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error al restablecer contraseña: $e");
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Obtener usuario actual
  User? get currentUser => _auth.currentUser;
}
