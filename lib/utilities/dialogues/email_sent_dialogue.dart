import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogues/generic_dialogue.dart';

Future<void> showPasswordResetSentDialogue(BuildContext context) {
  return showGenericDialogue(
      context: context,
      title: 'Password Reset',
      content: "Password sent to your mail id,please check your mail",
      optionsBuilder: () => {'Ok': null});
}
