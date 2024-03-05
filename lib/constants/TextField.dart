import 'package:flutter/material.dart';

import 'ColorGlobal.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData? suffixIconData;
  final bool obscureText;
  final Function(String)? onChanged;
  final FocusNode focusNode;
  final TextEditingController textEditingController;

  TextFieldWidget({
    required this.hintText,
    required this.prefixIconData,
    this.suffixIconData,
    required this.obscureText,
    this.onChanged,
    required this.textEditingController,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      controller: textEditingController,
      cursorColor: ColorGlobal.colorPrimary,
      focusNode: focusNode,
      style: const TextStyle(
        color: ColorGlobal.whiteColor,
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: ColorGlobal.whiteColor),
        focusColor: ColorGlobal.whiteColor,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: ColorGlobal.whiteColor),
        ),
        labelText: hintText,
        hintStyle:
            const TextStyle(color: ColorGlobal.colorPrimary, fontSize: 14),
        prefixIcon: Icon(
          prefixIconData,
          size: 20,
          color: ColorGlobal.whiteColor,
        ),
        suffixIcon: GestureDetector(
          child: Icon(
            suffixIconData,
            size: 20,
            color: ColorGlobal.whiteColor,
          ),
        ),
      ),
    );
  }
}
