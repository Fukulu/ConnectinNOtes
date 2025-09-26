import 'package:connectinnocase/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app/di.dart';
import 'presentation/cubit/notes_cubit.dart';
import 'presentation/pages/notes_page.dart';
import 'presentation/pages/sign_in_page.dart';
import 'presentation/pages/sign_up_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  final di = DI();
  await di.init();

  runApp(MyApp(di: di));
}

class MyApp extends StatelessWidget {
  final DI di;
  const MyApp({super.key, required this.di});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotesCubit(di.notesRepository)),
        BlocProvider(create: (_) => AuthCubit(
          signInUseCase: di.signInUseCase,
          signUpUseCase: di.signUpUseCase,
          signOutUseCase: di.signOutUseCase,
        )),
      ],
      child: MaterialApp(
        title: 'ConnectInno Notes',
        debugShowCheckedModeBanner: false,
        routes: {
          "/signin": (_) => const SignInPage(),
          "/signup": (_) => const SignUpPage(),
          "/notes": (_) => const NotesPage(),
        },
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // TAG - Firebase başlatılıyor
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // TAG - Kullanıcı giriş yapmış
        if (snapshot.hasData) {
          return const NotesPage();
        }

        // TAG - Kullanıcı yok → Sign In sayfası
        return const SignInPage();
      },
    );
  }
}
