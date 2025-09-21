import 'dart:io';



import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

String rgbToHex(Color color){
  return '${color.red.toRadixString(16).padLeft(2,'0')}${color.green.toRadixString(16).padLeft(2,'0')}${color.blue.toRadixString(16).padLeft(2,'0')}';
}

Color hexToColor(String hex) {
  return Color(int.parse(hex,radix: 16)+ 0xFF000000);
}

void showSnackBar(BuildContext context, String content)
{
  ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(content.toString()),
                ),
              );
}

Future<File?> pickAudio(BuildContext context) async{
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.audio
  
    );

    if (filePickerRes != null){
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
      showSnackBar(context, 'Error picking audio: $e');
      return null;
  }
}


Future<File?> pickImage(BuildContext context) async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (filePickerRes != null) {
      final pickedFile = File(filePickerRes.files.first.path!);
      final fileSize = await pickedFile.length();
      final maxFileSize = 10 * 1024 * 1024; // 10 MB, adjust this limit as needed
      
      if (fileSize > maxFileSize) {
        showSnackBar(context, 'Selected image is too large. Please select an image smaller than 10 MB.');
        return null;
      }
      return pickedFile;
    }
    return null;
  } catch (e) {
    showSnackBar(context, 'Error picking image: $e');
    return null;
  }
}


// Future<File?> pickImage(BuildContext context) async{
//   try {
//     final filePickerRes = await FilePicker.platform.pickFiles(
//       type: FileType.image
  
//     );

//     if (filePickerRes != null){
//       return File(filePickerRes.files.first.xFile.path);
//     }
//     return null;
//   } catch (e) {
//       showSnackBar(context, 'Error picking image: $e');
//       return null;
//   }
// }


Future<void> requestPermissions(BuildContext context) async {
  final status = await Permission.storage.request();
  if (status.isGranted) {
    // Permission granted, proceed with file picking
  } else {
    // Permission denied, handle accordingly
    showSnackBar(context, 'Storage permission is required to pick files.');
  }
}