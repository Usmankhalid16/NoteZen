import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Utils/CustomText.dart';
import '../Sticky Notes/sticky_notes_page.dart';

class EditStickyNotePage extends StatefulWidget {
  final StickyNote stickyNote;

  EditStickyNotePage({required this.stickyNote});

  @override
  _EditStickyNotePageState createState() => _EditStickyNotePageState();
}

class _EditStickyNotePageState extends State<EditStickyNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.stickyNote.title);
    _noteController = TextEditingController(text: widget.stickyNote.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Sticky Note', style: GoogleFonts.lato()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                widget.stickyNote.title = value;
              },
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              controller: _titleController,
            ),
            const SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                widget.stickyNote.text = value;
              },
              decoration: const InputDecoration(
                labelText: 'Note',
              ),
              controller: _noteController,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: CustomText(text: 'Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(widget.stickyNote);
          },
          child: CustomText(text: 'Save'),
        ),
      ],
    );
  }
}
