import 'package:crud_perpustakaan/home_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://jozwwsydfrennsyhyvse.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impvend3c3lkZnJlbm5zeWh5dnNlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE3MjgyMjIsImV4cCI6MjA0NzMwNDIyMn0.YRs9VwMifp5IP0vXTEjuL7uGR5kIoCkFIyYHfIYDhPE',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Digigital Library" ,
      home: BookListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

