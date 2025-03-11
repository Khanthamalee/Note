final String tableNotes = "notes";

class NoteField {
  static final List<String> values = [
    id,
    isImportant,
    number,
    title,
    description,
    time
  ];
  static final String id = '_id';
  static final String isImportant = "isImportant";
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class Notemodel {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createTime;

  Notemodel(
      {this.id,
      required this.isImportant,
      required this.number,
      required this.title,
      required this.description,
      required this.createTime});

  Notemodel copy(
          {int? id,
          bool? isImportant,
          int? number,
          String? title,
          String? description,
          DateTime? createTime}) =>
      Notemodel(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createTime: createTime ?? this.createTime,
      );

  static Notemodel fromJson(Map<String, Object?> json) => Notemodel(
        id: json[NoteField.id] as int?,
        isImportant: json[NoteField.isImportant] == 1,
        number: json[NoteField.number] as int,
        title: json[NoteField.title] as String,
        description: json[NoteField.description] as String,
        createTime: DateTime.parse(json[NoteField.time] as String),
      );

  Map<String, Object?> toJson() => {
        NoteField.id: id,
        NoteField.isImportant: isImportant ? 1 : 0,
        NoteField.number: number,
        NoteField.title: title,
        NoteField.description: description,
        NoteField.time: createTime.toIso8601String(),
      };
}
