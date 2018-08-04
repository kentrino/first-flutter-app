import 'package:flutter/material.dart';
import "package:first_app/screen/search_screen.dart";

class GithubSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text("Saved Suggestions"),
      ),
      body: SearchScreen(),
    );
  }
}
