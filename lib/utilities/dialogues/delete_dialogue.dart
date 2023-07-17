import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogues/generic_dialogue.dart';

Future<bool> showDeleteDialogue(BuildContext context) {
  return showGenericDialogue<bool>(
    context: context,
    title: "Delete Note",
    content: "Are you sure you want to delete?",
    optionsBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then((value) => value ?? false);
}
