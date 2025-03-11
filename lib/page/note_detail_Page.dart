import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/model/noteModel.dart';

import '../db/notes_database.dart';
import 'note_add_edit_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;
  const NoteDetailPage({Key? key, required this.noteId}) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Notemodel note;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    this.note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [_editButton(), _deleteButton()],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Text(
                  note.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  DateFormat.yMMMd().format(note.createTime),
                  style: TextStyle(color: Colors.white38),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  note.description,
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                )
              ],
            ),
    );
  }

  Widget _deleteButton() {
    return IconButton(
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.delete));
  }

  Widget _editButton() {
    return IconButton(
        onPressed: () async {
          if (isLoading) return;
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NoteAddEditPage()));
          refreshNote();
        },
        icon: Icon(Icons.edit_outlined));
  }
}
