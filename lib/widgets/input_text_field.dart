import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hinText;
  final TextInputType textInputType;
  final bool isPass;

  const TextFieldInput({Key? key,
    required this.textInputType,
    required this.hinText ,
    required this.textEditingController ,
    this.isPass=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hinText,
        fillColor: const Color(0xFFC9C9C9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFC9C9C9),
          ),
        ),
        focusedBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFC9C9C9),
          ),
        ),
        enabledBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFC9C9C9),
          ),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
