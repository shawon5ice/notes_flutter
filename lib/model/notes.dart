import 'dart:ffi';

final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, number, title, description, time
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class Note {
  int? id;
  final int? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final DateTime? createdTime;

  Note({
     this.id,
     this.isImportant,
     this.number,
     this.title,
     this.description,
     this.createdTime,
  });

  Note copy({
    int? id,
    int? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
    id: json[NoteFields.id] as int,
    isImportant: int.parse(json[NoteFields.isImportant].toString()),
    number: json[NoteFields.number] as int,
    title: json[NoteFields.title] as String,
    description: json[NoteFields.description] as String,
    createdTime: DateTime.parse(json[NoteFields.time] as String),
  );

  Map<String, Object> toJson() => {
    NoteFields.id: id?? int.parse(DateTime.now().toIso8601String().split('.').last),
    NoteFields.title: title.toString(),
    NoteFields.isImportant: isImportant??0,
    NoteFields.number: number??0,
    NoteFields.description: description??'--',
    NoteFields.time: createdTime != null? createdTime!.toIso8601String(): DateTime.now().toIso8601String(),
  };
}
