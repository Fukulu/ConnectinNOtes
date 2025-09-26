import 'package:hive/hive.dart';
import '../../domain/entities/note.dart';

part 'note_model.g.dart';

@HiveType(typeId: 1)
class NoteModel {
  @HiveField(0) String id;
  @HiveField(1) String title;
  @HiveField(2) String content;
  @HiveField(3) bool pinned;
  @HiveField(4) DateTime createdAt;
  @HiveField(5) DateTime updatedAt;
  @HiveField(6) bool dirty;           // offline değişiklik işareti

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.pinned,
    required this.createdAt,
    required this.updatedAt,
    this.dirty = false,
  });

  factory NoteModel.fromEntity(Note n) => NoteModel(
    id: n.id, title: n.title, content: n.content, pinned: n.pinned,
    createdAt: n.createdAt, updatedAt: n.updatedAt, dirty: false,
  );

  Note toEntity() => Note(
    id: id, title: title, content: content, pinned: pinned,
    createdAt: createdAt, updatedAt: updatedAt,
  );

  factory NoteModel.fromJson(Map<String,dynamic> j) => NoteModel(
    id: j['id'] as String,
    title: j['title'] as String,
    content: j['content'] as String,
    pinned: (j['pinned'] as bool?) ?? false,
    createdAt: DateTime.parse(j['createdAt']),
    updatedAt: DateTime.parse(j['updatedAt']),
  );

  Map<String,dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'pinned': pinned,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
  };
}