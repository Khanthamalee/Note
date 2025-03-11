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
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        child: _noteFormWidget(
          isImportant,
          number,
          title,
          description,
          (isImportant) => setState(() => this.isImportant = isImportant),
          (number) => setState(() => this.number = number),
          (title) => setState(() => this.title = title),
          (description) => setState(() => this.description = description),
        ),
      ),
    );
  }

  Widget _noteFormWidget(
      bool isImportant,
      int number,
      String title,
      String description,
      ValueChanged<bool> onChangedImportant,
      ValueChanged<int> onChangedNumber,
      ValueChanged<String> onChangedTitle,
      ValueChanged<String> onChangedDescription) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Switch(
                  value: isImportant ?? false,
                  onChanged: onChangedImportant,
                ),
                Expanded(
                  child: Slider(
                    value: (number ?? 0).toDouble(),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    onChanged: (number) => onChangedNumber(number.toInt()),
                  ),
                )
              ],
            ),
            buildTitle(onChangedTitle),
            const SizedBox(height: 8),
            buildDescription(onChangedDescription),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(
    ValueChanged<String> onChangedTitle,
  ) {
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.white70),
      ),
      validator: (title) =>
          title != null && title.isEmpty ? 'The title cannot be empty' : null,
      onChanged: onChangedTitle,
    );
  }

  Widget buildDescription(ValueChanged<String> onChangedDescription) =>
      TextFormField(
        maxLines: 5,
        initialValue: description,
        style: const TextStyle(color: Colors.white60, fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedDescription,
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrupdateNote,
        child: const Text('Save'),
      ),
    );
  }

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
}
