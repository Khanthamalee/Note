import 'package:flutter/material.dart';
import 'package:note/db/notes_database.dart';
import 'package:note/model/noteModel.dart';

class NoteAddEditPage extends StatefulWidget {
  final Notemodel? note;
  const NoteAddEditPage({super.key, this.note});

  @override
  State<NoteAddEditPage> createState() => _NoteAddEditPageState();
}

class _NoteAddEditPageState extends State<NoteAddEditPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String description;
  late String title;
  @override
  void addOrupdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      description: description,
    );
    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Notemodel(
        title: title,
        isImportant: true,
        number: number,
        description: description,
        createTime: DateTime.now());
    await NotesDatabase.instance.createNote(note);
  }

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
