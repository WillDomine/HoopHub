import 'package:flutter/material.dart';
import 'package:myapp/all.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up page"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  ListTile(
                    title: const Text("Email"),
                    subtitle: TextField(
                      controller: emailController,
                    ),
                  ),
                  ListTile(
                    title: const Text("Password"),
                    subtitle: TextField(
                      controller: passwordController,
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Register"),
                          onPressed: () async {
                            var (
                              request,
                              response
                            ) = await Auth().signUpWithEmail(
                                emailController.text, passwordController.text);
                            if (request) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                            } else {
                              if (response == "") {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ]),
          )),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?"),
            TextButton(
              child: const Text("Sign In"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
