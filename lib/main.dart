import 'package:flutter/material.dart';

import 'Database/db.dart';
import 'Screens/Sticky Notes/sticky_notes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  await DatabaseHelper().initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
            },
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white),
      home: StickyNotesPage(),
    );
  }
}
