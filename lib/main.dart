import 'package:pedidos_app/inherited/my_inherited.dart';
import 'package:pedidos_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// pedidos_app  flutter_application_1

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://semydismpnuaohbelama.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbXlkaXNtcG51YW9oYmVsYW1hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU0MzQ1MjcsImV4cCI6MjAzMTAxMDUyN30.vHQODbscconE6yV81kqo-cKACLUKyADlJFi6kuIspAw',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String tituloApp = 'DAF C.A';
    return GetInfoUser(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)),
        title: 'Material App',
        home: HomeScreen(titulo: tituloApp),
      ),
    );
  }
}
