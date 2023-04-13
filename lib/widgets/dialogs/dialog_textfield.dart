import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/material.dart';

class DialogTextfield extends StatelessWidget {
  DialogTextfield({
    @required this.placeholder,
    @required this.textEditingController,
    this.obscureText = false,
  });

  final String placeholder;
  final TextEditingController textEditingController;
  final bool obscureText;

  Widget build(BuildContext context) {
    final border = const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFE3E7E9),
      ),
    );

    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        hintText: placeholder,
        hintStyle: TextStyle(
          color: ColorConstants.hintTextColor,
          fontSize: 14,
        ),
      ),
      controller: textEditingController,
    );
  }
}
