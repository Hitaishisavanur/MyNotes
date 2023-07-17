import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogues/generic_dialogue.dart';

Future<void> showErrorDialogue(
  BuildContext context,
  String text,
) {
  return showGenericDialogue<void>(
    context: context,
    title: "An Error Occured",
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
