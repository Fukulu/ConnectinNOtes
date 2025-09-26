import '../repositories/notes_repository.dart';
import '../entities/note.dart';
import '../../core/result.dart';

class CreateNote {
  final NotesRepository repo;
  CreateNote(this.repo);

  Future<Result<Note>> call(String title, String content, {bool pinned = false}) {
    return repo.create(title, content, pinned: pinned);
  }
}
