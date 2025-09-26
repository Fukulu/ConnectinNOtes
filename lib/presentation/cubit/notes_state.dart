import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';

enum NotesStatus { initial, loading, loaded, error }

class NotesState extends Equatable {
  final NotesStatus status;
  final List<Note> notes;
  final String? message;
  final String query;

  const NotesState({
    this.status = NotesStatus.initial,
    this.notes = const [],
    this.message,
    this.query = '',
  });

  NotesState copyWith({
    NotesStatus? status,
    List<Note>? notes,
    String? message,
    String? query,
  }) {
    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      message: message,
      query: query ?? this.query,
    );
  }

  // TAG - Arama filtresine göre sonuç döner
  List<Note> get filtered {
    if (query.isEmpty) return notes;
    return notes.where((n) =>
    n.title.toLowerCase().contains(query.toLowerCase()) ||
        n.content.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  @override
  List<Object?> get props => [status, notes, message, query];
}
