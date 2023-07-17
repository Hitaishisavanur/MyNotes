import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogues/generic_dialogue.dart';

Future<bool> showLogoutDialogue(BuildContext context) {
  return showGenericDialogue<bool>(
    context: context,
    title: "Log out",
    content: "Are you sure you want to logout?",
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}
