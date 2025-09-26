import 'package:uuid/uuid.dart';
import '../../core/network_info.dart';
import '../../core/result.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/local/notes_local_ds.dart';
import '../datasources/remote/notes_remote_ds.dart';
import '../models/note_model.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDS local;
  final NotesRemoteDS remote;
  final NetworkInfo net;
  NotesRepositoryImpl({required this.local, required this.remote, required this.net});

  @override
  Future<Result<List<Note>>> getNotes() async {
    // her zaman önce local göster
    final localList = await local.getAll();
    // online ise remote ile sync çek
    if (await net.isOnline) {
      try {
        final remoteList = await remote.fetchAll();
        // remote -> local’i güncelle
        for (final m in remoteList) { await local.upsert(m..dirty = false); }
        final refreshed = await local.getAll();
        return Ok(refreshed.map((e)=>e.toEntity()).toList());
      } catch (_) {}
    }
    return Ok(localList.map((e)=>e.toEntity()).toList());
  }

  @override
  Future<Result<Note>> create(String title, String content, {bool pinned=false}) async {
    final now = DateTime.now().toUtc();
    final localModel = NoteModel(
      id: const Uuid().v4(), title: title, content: content,
      pinned: pinned, createdAt: now, updatedAt: now, dirty: true,
    );
    await local.upsert(localModel);

    if (await net.isOnline) {
      try {
        final created = await remote.create(localModel);
        await local.upsert(created..dirty=false);
        return Ok(created.toEntity());
      } catch (e) {}
    }
    return Ok(localModel.toEntity()); // offline başarı
  }

  @override
  Future<Result<Note>> update(Note n) async {
    final model = NoteModel.fromEntity(n.copyWith(updatedAt: DateTime.now().toUtc()));
    model.dirty = true;
    await local.upsert(model);

    if (await net.isOnline) {
      try {
        final updated = await remote.update(model);
        await local.upsert(updated..dirty=false);
        return Ok(updated.toEntity());
      } catch (e) {}
    }
    return Ok(model.toEntity());
  }

  @override
  Future<Result<void>> delete(String id) async {
    await local.delete(id);
    if (await net.isOnline) {
      try { await remote.delete(id); } catch (e) {}
    }
    return Ok(null);
  }

  @override
  Future<void> sync() async {
    if (!await net.isOnline) return;
    final dirty = local.dirtyOnes();
    for (final m in dirty) {
      try {
        await remote.update(m);
        await local.markDirty(m.id, dirty:false);
      } catch (_) {}
    }
  }
}
