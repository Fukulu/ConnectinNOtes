import 'package:connectinnocase/core/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
  }) : super(const AuthState());

  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await signInUseCase(email, password);
    result.when(
      ok: (_) => emit(state.copyWith(status: AuthStatus.success)),
      err: (msg) => emit(state.copyWith(status: AuthStatus.failure, error: msg)),
    );
  }

  Future<void> signUp(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await signUpUseCase(email, password);
    result.when(
      ok: (_) => emit(state.copyWith(status: AuthStatus.success)),
      err: (msg) => emit(state.copyWith(status: AuthStatus.failure, error: msg)),
    );
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await signOutUseCase();
    result.when(
      ok: (_) => emit(state.copyWith(status: AuthStatus.success)),
      err: (msg) => emit(state.copyWith(status: AuthStatus.failure, error: msg)),
    );
  }
}
