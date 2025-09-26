import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';
import '../../core/result.dart';

class SignUpUseCase {
  final AuthRepository repo;
  SignUpUseCase(this.repo);

  Future<Result<UserEntity>> call(String email, String password) {
    return repo.signUp(email, password);
  }
}
