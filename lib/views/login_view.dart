import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogues/error_dialogue.dart';
import 'package:mynotes/utilities/dialogues/loading_dialogue.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialogue? _closeDialogueHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialogue = _closeDialogueHandle;
          if (!state.isLoading && closeDialogue != null) {
            closeDialogue();
            _closeDialogueHandle = null;
          } else if (state.isLoading && closeDialogue == null) {
            _closeDialogueHandle =
                showLoadingDialogue(context: context, text: "Loading....");
          }

          if (state.exception is WrongPasswordAuthException ||
              state.exception is UserNotFoundAuthException) {
            await showErrorDialogue(context, 'Wrong Credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialogue(context, 'Authentication Error');
          }
        }
      },
      child: Scaffold(
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
              decoration:
                  const InputDecoration(hintText: "Enter your password"),
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
            ),
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  context.read<AuthBloc>().add(
                        AuthEventLogin(email, password),
                      );
                },
                child: const Text("Login")),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventShouldRegister());
              },
              child: const Text("Not registed? Register here"),
            ),
          ],
        ),
      ),
    );
  }
}
