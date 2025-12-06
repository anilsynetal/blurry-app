

import 'package:flutter/cupertino.dart';

import '../../core/utils/export.dart';

void showErrorMessageDialog(String message,{String ?heading}) {
  // showMessage(Get.overlayContext!,message, MessageType.error);
  //
  // // Show Cupertino dialog for long messages
  // if (message.length > 50) {
  showCupertinoDialog(
    context: Get.overlayContext!,
    builder: (context) => CupertinoAlertDialog(
      title:  Text(heading??"Error Details"),
      content: Text(
        message,
        style: TextStyles.bodyMedium,
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
  // }
}


 showMessageDialog(String message,String title) async{
  // showMessage(Get.overlayContext!,message, MessageType.error);
  //
  // // Show Cupertino dialog for long messages
  // if (message.length > 50) {
 await showCupertinoDialog(
    context: Get.overlayContext!,
    builder: (context) => CupertinoAlertDialog(
      title:  Text("${title}"),
      content: Text(
        message,
        style: TextStyles.bodyMedium,
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
  // }
}