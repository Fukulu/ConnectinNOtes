import '../repositories/notes_repository.dart';
import '../entities/note.dart';
import '../../core/result.dart';

class GetNotes {
  final NotesRepository repo;
  GetNotes(this.repo);

  Future<Result<List<Note>>> call() {
    return repo.getNotes();
  }
}
