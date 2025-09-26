import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/note_card.dart';
import '../widgets/notes_search_bar.dart';
import 'note_edit_page.dart';
import 'sign_in_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Color> cardColors = [
    Colors.green.shade100,
    Colors.purple.shade100,
    Colors.red.shade100,
    Colors.yellow.shade100,
    Colors.blue.shade100,
    Colors.pink.shade100,
  ];

  @override
  void initState() {
    super.initState();
    context.read<NotesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          "My Notes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // 🔑 Logout işlemi
              await context.read<AuthCubit>().signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInPage()),
                      (route) => false,
                );
              }
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state.status == NotesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.notes.isEmpty) {
            return const Center(child: Text("No notes yet."));
          }

          final notes = state.filtered;

          return Column(
            children: [
              NotesSearchBar(
                onChanged: (q) => context.read<NotesCubit>().setQuery(q),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final color = cardColors[index % cardColors.length];
                      return NoteCard(
                        note: note,
                        backgroundColor: color,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NoteEditPage(
                                note: note,
                                backgroundColor: color,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final color =
          cardColors[DateTime.now().millisecond % cardColors.length];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteEditPage(
                note: null,
                backgroundColor: color,
              ),
            ),
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
