import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> getIdToken() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }
}
