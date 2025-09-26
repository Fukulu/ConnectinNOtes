import '../repositories/notes_repository.dart';
import '../../core/result.dart';

class DeleteNote {
  final NotesRepository repo;
  DeleteNote(this.repo);

  Future<Result<void>> call(String id) {
    return repo.delete(id);
  }
}
