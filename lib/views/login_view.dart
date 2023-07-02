import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialogue.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController(); // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose(); // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration:
                const InputDecoration(hintText: "Enter your Email address"),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: "Enter your password"),
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  final userCredential = await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      noteRoute,
                      (route) => false,
                    );
                  } else {
                    AuthService.firebase().sendEmailVerification();
                    Navigator.of(context).pushNamed(
                      verifyEmailRoute,
                    );
                  }
                  devtools.log(userCredential.toString());
                } on UserNotFoundAuthException {
                  await showErrorDialogue(
                    context,
                    "user not found",
                  );
                } on WrongPasswordAuthException {
                  await showErrorDialogue(context, "wrong credentials");
                } on GenericAuthException {
                  await showErrorDialogue(context, "Authentication error");
                } catch (e) {
                  await showErrorDialogue(context, e.toString());
                }
              },
              child: const Text("Login")),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Not registed? Register here"),
          ),
        ],
      ),
    );
  }
}
