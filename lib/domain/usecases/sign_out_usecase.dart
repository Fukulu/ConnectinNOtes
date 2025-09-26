import '../repositories/auth_repository.dart';
import '../../core/result.dart';

class SignOutUseCase {
  final AuthRepository repo;
  SignOutUseCase(this.repo);

  Future<Result<void>> call() {
    return repo.signOut();
  }
}
