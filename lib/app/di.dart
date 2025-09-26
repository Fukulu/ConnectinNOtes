import 'package:connectivity_plus/connectivity_plus.dart';

import '../core/network_info.dart';
import '../data/datasources/local/hive_adapters.dart';
import '../data/datasources/local/notes_local_ds.dart';
import '../data/datasources/remote/api_client.dart';
import '../data/datasources/remote/notes_remote_ds.dart';
import '../data/repositories/notes_repository_impl.dart';
import '../domain/repositories/notes_repository.dart';

// ✅ Auth importları
import '../data/datasources/remote/auth_remote_ds.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';

class DI {
  // Notes
  late final NetworkInfo networkInfo;
  late final NotesRepository notesRepository;

  // Auth
  late final AuthRepository authRepository;
  late final SignInUseCase signInUseCase;
  late final SignUpUseCase signUpUseCase;
  late final SignOutUseCase signOutUseCase;

  Future<void> init() async {
    // Hive başlat
    await HiveInit.init();

    // servisleri hazırla
    networkInfo = NetworkInfo(Connectivity());
    final api = ApiClient();
    final remoteNotes = NotesRemoteDS(api);
    final local = NotesLocalDS();

    // notes repo
    notesRepository = NotesRepositoryImpl(
      local: local,
      remote: remoteNotes,
      net: networkInfo,
    );

    // auth repo
    final authRemote = AuthRemoteDS();
    authRepository = AuthRepositoryImpl(authRemote);

    // usecases
    signInUseCase = SignInUseCase(authRepository);
    signUpUseCase = SignUpUseCase(authRepository);
    signOutUseCase = SignOutUseCase(authRepository);
  }
}
