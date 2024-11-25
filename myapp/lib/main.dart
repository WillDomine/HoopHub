import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/entry_portal_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gxcovwasyqjuaevynldc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd4Y292d2FzeXFqdWFldnlubGRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEwODQ2NzEsImV4cCI6MjA0NjY2MDY3MX0.Ywuc_FSoLs5iiBC7rVyErxaSXW5Le-HhPTPPCvRgWqI',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HoopHub',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const EntryPortal(),
    );
  }
}
