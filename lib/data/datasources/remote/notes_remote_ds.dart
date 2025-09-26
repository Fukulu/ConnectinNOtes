import 'package:dio/dio.dart';
import '../../models/note_model.dart';
import 'api_client.dart';

class NotesRemoteDS {
  final ApiClient api;
  NotesRemoteDS(this.api);

  Future<List<NoteModel>> fetchAll() async {
    final res = await api.client.get('/notes');
    final list = (res.data as List).cast<Map<String,dynamic>>();
    return list.map((j)=>NoteModel.fromJson(j)).toList();
  }

  Future<NoteModel> create(NoteModel m) async {
    final res = await api.client.post('/notes', data: {
      'title': m.title,
      'content': m.content,
      'pinned': m.pinned,
    });
    return NoteModel.fromJson(res.data as Map<String,dynamic>);
  }

  Future<NoteModel> update(NoteModel m) async {
    final res = await api.client.put('/notes/${m.id}', data: {
      'title': m.title, 'content': m.content, 'pinned': m.pinned,
    });
    return NoteModel.fromJson({
      ...m.toJson(),
      ...res.data as Map<String,dynamic>,
      'id': m.id,
    });
  }

  Future<void> delete(String id) async {
    await api.client.delete('/notes/$id');
  }
}
