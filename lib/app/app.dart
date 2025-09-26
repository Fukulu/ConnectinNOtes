import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/notes_repository.dart';
import '../presentation/cubit/notes_cubit.dart';
import '../presentation/pages/notes_page.dart';

class MyApp extends StatelessWidget {
  final NotesRepository repo;
  const MyApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConnectInno Notes',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.black,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          scrolledUnderElevation: 4,
          surfaceTintColor: Colors.black,
        ),
      ),
      home: BlocProvider(
        create: (_) => NotesCubit(repo),
        child: const NotesPage(),
      ),
    );
  }
}
