import 'package:flutter/material.dart';
import 'package:vexa_eleicoes/Views/await_screen.dart';
import 'dart:core';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: AwaitScreen()));
}
