import 'package:flutter/material.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EntryPortal extends StatefulWidget {
  const EntryPortal({super.key});

  @override
  State<EntryPortal> createState() => _EntryPortalState();
}

class _EntryPortalState extends State<EntryPortal> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Entry Portal'),
          centerTitle: false,
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      title: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    ListTile(
                      title: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            child: const Text('Sign Up'),
                            onPressed: () async {
                              if (await AuthService.signUp(emailController.text,
                                  passwordController.text)) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            child: const Text('Sign In'),
                            onPressed: () async {
                              if (await AuthService.signIn(emailController.text,
                                  passwordController.text)) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ]),
            ))));
  }
}
