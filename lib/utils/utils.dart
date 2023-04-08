
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async{
  final ImagePicker imagePicker =ImagePicker();
  XFile? _file = await imagePicker.pickImage(source: source);
  if(_file!=null){
    return await _file.readAsBytes();
  }
  print("Image Not Selected");
}


showSnakBar(String content,BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));

}