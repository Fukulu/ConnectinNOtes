import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/entities/user_entity.dart';

class AuthRemoteDS {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserEntity> signIn(String email, String password) async {
    final userCred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCred.user!;
    return UserEntity(uid: user.uid, email: user.email);
  }

  Future<UserEntity> signUp(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCred.user!;
    return UserEntity(uid: user.uid, email: user.email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
