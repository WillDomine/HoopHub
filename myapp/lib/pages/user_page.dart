import 'package:flutter/material.dart';
import 'package:myapp/main.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('User Page'),
      centerTitle: false,
      actions: [
        IconButton(
            icon: Icon(false ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {}),
      ],
    ));
  }
}
