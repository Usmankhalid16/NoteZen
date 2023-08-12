import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/CustomText.dart';

class AddStickyNotePage extends StatefulWidget {
  @override
  _AddStickyNotePageState createState() => _AddStickyNotePageState();
}

class _AddStickyNotePageState extends State<AddStickyNotePage> {
  String noteTitle = '';
  String noteText = '';
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Add Sticky Note'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  CustomText(text: 'Title'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  noteTitle = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [CustomText(text: 'Note')],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  noteText = value;
                },
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'Note Something Down',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  CustomText(
                    text: 'Select color: ',
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: CustomText(
                              text: 'Select Color',
                            ),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: _selectedColor,
                                onColorChanged: (Color color) {
                                  setState(() {
                                    _selectedColor = color;
                                  });
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: CustomText(text: 'Done'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Change',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    'title': noteTitle,
                    'text': noteText,
                    'color': _selectedColor,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  elevation: 2,
                ),
                child: CustomText(
                  text: 'Add',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
