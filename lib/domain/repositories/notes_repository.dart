import '../entities/note.dart';
import '../../core/result.dart';

abstract class NotesRepository {
  Future<Result<List<Note>>> getNotes();
  Future<Result<Note>> create(String title, String content, {bool pinned = false});
  Future<Result<Note>> update(Note note);
  Future<Result<void>> delete(String id);
  Future<void> sync();
}
