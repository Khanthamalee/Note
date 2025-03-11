import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/db/notes_database.dart';
import 'package:note/model/noteModel.dart';
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
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readAllNotes();
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
          // await Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => AddEditPage()));
          // refreshNote();
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
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Text(
            DateFormat.yMMMd().format(note.createTime),
            style: TextStyle(color: Colors.white38),
          ),
          Text(
            note.title,
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
