import 'package:hive/hive.dart';
import '../../models/note_model.dart';
import 'hive_adapters.dart';

class NotesLocalDS {
  Box<NoteModel> get _box => Hive.box<NoteModel>(HiveInit.notesBox);

  Future<List<NoteModel>> getAll() async => _box.values.toList()
    ..sort((a,b){
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

  Future<void> upsert(NoteModel m) async => _box.put(m.id, m);
  Future<void> delete(String id) async => _box.delete(id);
  Future<void> markDirty(String id, {bool dirty = true}) async {
    final m = _box.get(id);
    if (m != null) {
      m.dirty = dirty;
      await _box.put(id, m);
    }
  }

  List<NoteModel> dirtyOnes() =>
      _box.values.where((e) => e.dirty == true).toList();
}
