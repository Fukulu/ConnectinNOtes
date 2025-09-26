import '../../core/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_ds.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDS remote;
  AuthRepositoryImpl(this.remote);

  @override
  Future<Result<UserEntity>> signIn(String email, String password) async {
    try {
      final user = await remote.signIn(email, password);
      return Ok(user);
    } catch (e) {
      // 🔑 Firebase hatası ne olursa olsun tek mesaj dön
      return const Err("Please check your information");
    }
  }

  @override
  Future<Result<UserEntity>> signUp(String email, String password) async {
    try {
      final user = await remote.signUp(email, password);
      return Ok(user);
    } catch (e) {
      return const Err("Please check your information");
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await remote.signOut();
      return const Ok(null);
    } catch (e) {
      return const Err("An error occurred, please try again");
    }
  }
}
