import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';
import '../../core/result.dart';

class SignInUseCase {
  final AuthRepository repo;
  SignInUseCase(this.repo);

  Future<Result<UserEntity>> call(String email, String password) {
    return repo.signIn(email, password);
  }
}
