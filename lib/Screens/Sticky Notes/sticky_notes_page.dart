import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Database/db.dart';
import '../../Utils/CustomText.dart';
import '../../Utils/greetings.dart';
import '../Input Screen/input_screen.dart';

final Uri _url = Uri.parse('https://github.com/Usmankhalid16');
final Uri _url2 = Uri.parse('https://www.linkedin.com/in/usman-khalid16/');

class StickyNote {
  int id;
  String title;
  String text;
  final Color color;

  StickyNote({
    required this.id,
    required this.title,
    required this.text,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'color': color.value,
    };
  }

  factory StickyNote.fromJson(Map<String, dynamic> json) {
    return StickyNote(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      color: Color(json['color']),
    );
  }
}

class StickyNotesPage extends StatefulWidget {
  @override
  _StickyNotesPageState createState() => _StickyNotesPageState();
}

class _StickyNotesPageState extends State<StickyNotesPage> {
  int _highestId = 0;
  List<StickyNote> stickyNotes = [];

  @override
  void initState() {
    super.initState();
    _loadStickyNotes();
  }

  void _loadStickyNotes() async {
    try {
      List<Map<String, dynamic>> notes =
          await DatabaseHelper().getStickyNotes();
      setState(() {
        stickyNotes = notes.map((note) {
          final stickyNote = StickyNote(
            id: note['id'],
            title: note['title'],
            text: note['text'],
            color: Color(note['color']),
          );
          if (stickyNote.id > _highestId) {
            _highestId = stickyNote.id;
          }
          return stickyNote;
        }).toList();
      });
    } catch (e) {
      print("Error loading sticky notes: $e");
    }
  }

  void _saveStickyNotes() async {
    final db = DatabaseHelper();
    for (StickyNote note in stickyNotes) {
      await db.insertStickyNote(note);
    }
  }

  void addStickyNote() async {
    Map<String, dynamic> newNoteData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStickyNotePage(),
      ),
    );

    if (newNoteData != null) {
      setState(() {
        String noteTitle = newNoteData['title'];
        String noteText = newNoteData['text'];
        Color selectedColor = newNoteData['color'];

        if (noteText.isNotEmpty) {
          int newNoteId = _highestId + 1;
          _highestId = newNoteId;

          stickyNotes.add(
            StickyNote(
              id: newNoteId,
              title: noteTitle,
              text: noteText,
              color: selectedColor,
            ),
          );
          _saveStickyNotes(); // Moved inside setState
          print("Note added with ID: $newNoteId");
        }
      });
    }
  }

  void deleteStickyNote(int index) async {
    final deletedNote = stickyNotes[index];
    await DatabaseHelper().deleteStickyNote(deletedNote.id);

    setState(() {
      stickyNotes.removeAt(index);
      _saveStickyNotes(); // Moved inside setState
      print("Note deleted with ID: ${deletedNote.id}");
    });
  }

  void showStickyNoteDialog(StickyNote stickyNote) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String noteTitle = stickyNote.title;
        String noteText = stickyNote.text;

        return AlertDialog(
          title: Text('Edit Sticky Note', style: GoogleFonts.lato()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    noteTitle = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  controller: TextEditingController(text: stickyNote.title),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    noteText = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Note',
                  ),
                  controller: TextEditingController(text: stickyNote.text),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: CustomText(
                text: 'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  stickyNote.title = noteTitle;
                  stickyNote.text = noteText;
                  _saveStickyNotes();
                });
                Navigator.of(context).pop();
              },
              child: CustomText(
                text: 'Save',
              ),
            ),
          ],
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDay = DateFormat.EEEE().format(now);
    String formattedDate = DateFormat.yMMMMd().format(now);
    String greetingText = getGreetingText(now.hour);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_outlined),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: const Icon(
                Icons.account_circle_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  CustomText(
                    text: 'INSANE',
                    size: 36,
                    weight: FontWeight.bold,
                    spacing: 9.3,
                  ),
                  CustomText(
                    text: 'STUDIOS',
                    size: 36,
                    weight: FontWeight.bold,
                    spacing: 4,
                  ),
                ],
              ),
            ),
            ListTile(
              title: CustomText(
                text: 'Developed by: Usman Khalid',
              ),
              onTap: () {
                // Handle navigation or action for this item
              },
            ),
            ListTile(
              leading: Icon(SimpleIcons.github),
              title: CustomText(
                text: 'Github',
              ),
              onTap: () {
                _launchUrl();
              },
            ),
            ListTile(
              leading: Icon(SimpleIcons.linkedin),
              title: CustomText(
                text: 'LinkedIn',
              ),
              onTap: () {
                _launchUrl1();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                  size: 36,
                  weight: FontWeight.bold,
                  text: greetingText,
                  color: Colors.black,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                CustomText(
                  size: 24,
                  weight: FontWeight.bold,
                  text: '$formattedDay',
                  color: Colors.black,
                ),
              ],
            ),
            Row(
              children: [
                CustomText(
                  size: 14,
                  weight: FontWeight.normal,
                  text: '$formattedDate',
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Flexible(
              child: ListView.builder(
                itemCount: stickyNotes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => showStickyNoteDialog(stickyNotes[index]),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                      padding: EdgeInsets.all(10.0),
                      height: 120.0,
                      decoration: BoxDecoration(
                        color: stickyNotes[index].color,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: stickyNotes[index].title,
                                  size: 18,
                                  weight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 8.0),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: CustomText(
                                      text: stickyNotes[index].text,
                                      weight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => deleteStickyNote(index),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addStickyNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                elevation: 2,
              ),
              child: CustomText(
                text: 'Add Sticky Note',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

Future<void> _launchUrl1() async {
  if (!await launchUrl(_url2)) {
    throw Exception('Could not launch $_url');
  }
}
