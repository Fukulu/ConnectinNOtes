import '../repositories/notes_repository.dart';
import '../entities/note.dart';
import '../../core/result.dart';

class UpdateNote {
  final NotesRepository repo;
  UpdateNote(this.repo);

  Future<Result<Note>> call(Note note) {
    return repo.update(note);
  }
}
