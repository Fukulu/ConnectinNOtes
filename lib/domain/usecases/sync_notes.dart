import '../repositories/notes_repository.dart';

class SyncNotes {
  final NotesRepository repo;
  SyncNotes(this.repo);

  Future<void> call() {
    return repo.sync();
  }
}