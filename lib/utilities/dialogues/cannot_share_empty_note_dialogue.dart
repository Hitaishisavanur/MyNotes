import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogues/generic_dialogue.dart';

Future<void> showCannotShareEmptyNoteDialogue(BuildContext context) {
  return showGenericDialogue(
    context: context,
    title: 'Sharing',
    content: "You cannot share a empty note",
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
