import 'package:flutter/material.dart';
import 'package:tugas_uasppb/screens/sign_in/sign_in_screen.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas UAS PBB',
      initialRoute: LoginScreen.routeName,
      routes: routes,
    );
  }
}