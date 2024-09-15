import 'package:flutter/material.dart';
import 'package:myapp/all.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In page"),
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
                  // email input
                  ListTile(
                    title: const Text("Email"),
                    subtitle: TextField(controller: emailController),
                  ),

                  // password input
                  ListTile(
                    title: const Text("Password"),
                    subtitle: TextField(
                      controller: passwordController,
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // login button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Login"),
                          onPressed: () async {
                            // login
                            var (
                              request,
                              response
                            ) = await Auth().signInWithEmail(
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(response),
                              ));
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),

                  // forgot password
                  TextButton(
                      onPressed: () {
                        TextEditingController forgotPasswordEmailController =
                            TextEditingController();
                        AlertDialog alert = AlertDialog(
                          title: const Text("Forgot Password"),
                          content: TextField(
                            controller: forgotPasswordEmailController,
                            decoration: const InputDecoration(
                              labelText: "Email",
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () async {
                                  if (await Auth().resetPassword(
                                      forgotPasswordEmailController.text)) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Password reset link sent to your email."),
                                    ));
                                  }
                                },
                                child: const Text("Submit"))
                          ],
                        );
                        showDialog(
                            context: context, builder: (context) => alert);
                      },
                      child: const Text("Forgot Password?"))
                ]),
          )),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: const Text("Register"))
          ],
        ),
      ),
    );
  }
}

class CustomStyles {
  static const headerStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const bodyStyle = TextStyle(fontSize: 20);
}
