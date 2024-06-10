import 'package:flutter/material.dart';
import 'package:tugas_uasppb/screens/home/components/home_page.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24), // Increased padding
          child: Column(
            children: [
              SizedBox(
                height: 200, // Increased height to accommodate larger banner
                child: Placeholder(), // Placeholder for the banner
              ),
              SizedBox(height: 30), // Increased spacing
              HomePage(),
            ],
          ),
        ),
      ),
    );
  }
}
