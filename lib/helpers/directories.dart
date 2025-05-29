import 'dart:io';

import 'package:calliopen/exceptions/files/no_directory_permission.dart';
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> canPickDirectory() async {
  if (Platform.isAndroid) {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    final status = await Permission.manageExternalStorage.request();
    print(status);
    return status.isGranted;
  } else {
    return false;
  }
}

Future<Directory?> pickDirectory({
  bool allowFolderCreation = false,
  required BuildContext context,
  bool barrierDismissible = true,
  Color? backgroundColor,
  String? message,
  ShapeBorder? shape,
}) async {
  if (!await canPickDirectory()) throw NoDirectoryPermission();

  Directory directory = Directory(FolderPicker.rootPath);

  if (!context.mounted) return null;

  return await FolderPicker.pick(
    allowFolderCreation: allowFolderCreation,
    context: context,
    rootDirectory: directory,
    backgroundColor: backgroundColor,
    message: message,
    shape: shape,
    barrierDismissible: barrierDismissible,
  );
}
