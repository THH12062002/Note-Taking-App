import 'package:flutter/material.dart';
import 'package:note_taking_app/note.dart';
import 'package:note_taking_app/note_database.dart';
import 'package:note_taking_app/note_page.dart';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Taking App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NoteListPage(),
    );
  }
}

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<Note> notes = [];
  final _db = NoteDatabase.instance;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final data = await _db.getAllNotes();
    setState(() => notes = data);
  }

  void _deleteNote(int id) async {
    await _db.deleteNote(id);
    _loadNotes();
  }

  void _navigateToNotePage([Note? note]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NotePage(note: note)),
    );
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: notes.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(note.content),
                    onTap: () => _navigateToNotePage(note),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(note.id!),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToNotePage(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Hiển thị trạng thái khi không có ghi chú nào
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.note, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'Chưa có ghi chú nào!',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const Text('Just test github.dev!', style:TextStyle(fontSize: 18, color: Colors.grey),),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _navigateToNotePage(),
            child: const Text('Thêm ghi chú đầu tiên'),
          ),
        ],
      ),
    );
  }
}
