import 'package:broaden/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [Colors.purple, Colors.indigo],
            ),
          ),
          child: Container(
            color: Colors.black38,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 120, 8, 8),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Broaden",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 70),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Email",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Password",
                          ),
                        ),
                      ),
                      MaterialButton(
                        height: 40.0,
                        minWidth: 100.0,
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Text("Log In"),
                        onPressed: () => {
                          context.read<AuthenticationService>().signIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              )
                        },
                        splashColor: Colors.redAccent,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
