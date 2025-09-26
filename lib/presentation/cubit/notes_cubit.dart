import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../core/result.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NotesRepository repo;

  NotesCubit(this.repo) : super(const NotesState());

  Future<void> load() async {
    emit(state.copyWith(status: NotesStatus.loading));
    final res = await repo.getNotes();
    switch (res) {
      case Ok(data: final list):
        emit(state.copyWith(status: NotesStatus.loaded, notes: list));
      case Err(message: final m):
        emit(state.copyWith(status: NotesStatus.error, message: m));
    }
  }

  Future<void> create(String title, String content, {bool pinned = false}) async {
    final res = await repo.create(title, content, pinned: pinned);
    if (res is Ok<Note>) {
      emit(state.copyWith(notes: [res.data, ...state.notes]));
    } else if (res is Err<Note>) {
      emit(state.copyWith(status: NotesStatus.error, message: res.message));
    }
  }

  Future<void> update(Note note) async {
    final res = await repo.update(note);
    if (res is Ok<Note>) {
      final list = state.notes.map((n) => n.id == res.data.id ? res.data : n).toList();
      emit(state.copyWith(notes: list));
    } else if (res is Err<Note>) {
      emit(state.copyWith(status: NotesStatus.error, message: res.message));
    }
  }

  Future<void> delete(String id) async {
    final oldNotes = state.notes;
    emit(state.copyWith(notes: oldNotes.where((n) => n.id != id).toList()));

    final res = await repo.delete(id);
    if (res is Err<void>) {
      // TAG - başarısız olursa eski listeyi geri koy
      emit(state.copyWith(notes: oldNotes, status: NotesStatus.error, message: res.message));
    }
  }

  void setQuery(String q) {
    emit(state.copyWith(query: q));
  }
}
