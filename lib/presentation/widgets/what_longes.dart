
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoungeInfoDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text("💫 What’s the Lounge?"),
      content: const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          "The Lounge is a space to chat and connect with active members in real time. "
              "Meet new people, share vibes, and discover instant matches!",
          style: TextStyle(fontSize: 14),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
