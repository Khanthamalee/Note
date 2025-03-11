import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/db/notes_database.dart';
import 'package:note/model/noteModel.dart';
import 'package:note/page/note_add_edit_page.dart';
import 'package:note/page/note_detail_Page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Notemodel> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    print("notes");
    print(notes);
    setState(() => isLoading = false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          Icon(Icons.search),
          SizedBox(
            width: 12,
          )
        ],
      ),
      body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
                  ? Text(
                      "No notes",
                      style: TextStyle(color: Colors.white),
                    )
                  : buildNotes()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NoteAddEditPage()));
          refreshNote();
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildNotes() {
    return GridView.builder(
      itemCount: notes.length,
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        final note = notes[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!)));
            // refreshNote();
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _noteCard(note, index),
          ),
        );
      },
    );
  }

  Widget _noteCard(Notemodel note, int index) {
    final _lightColors = [
      Colors.amber.shade300,
      Colors.lightGreen.shade300,
      Colors.lightBlue.shade300,
      Colors.orange.shade300,
      Colors.pinkAccent.shade100,
      Colors.tealAccent.shade100
    ];
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.createTime);
    final minHeight = getMinHeight(index);
    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              note.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
