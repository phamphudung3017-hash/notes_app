// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import '../screens/note_editor_screen.dart';
import '../models/note.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final provider = Provider.of<NoteProvider>(context, listen: false);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('Are you sure you want to delete this note? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok ?? false) {
      if (note.id != null) {
        await provider.deleteNote(note.id!);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note deleted')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.loadNotes,
              child: provider.notes.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(child: Text('No notes yet. Tap + to add a note.')),
                      ],
                    )
                  : ListView.builder(
                      itemCount: provider.notes.length,
                      itemBuilder: (context, index) {
                        final note = provider.notes[index];
                        return NoteCard(
                          note: note,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => NoteEditorScreen(note: note)));
                          },
                          onEdit: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => NoteEditorScreen(note: note)));
                          },
                          onDelete: () => _confirmDelete(context, note),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NoteEditorScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
