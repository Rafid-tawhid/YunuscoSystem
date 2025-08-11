import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String labelText;
  final IconData? prefixIcon;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color textColor;
  final Color iconColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final double borderRadius;
  final bool isFocused;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textColor = Colors.white70,
    this.iconColor = Colors.white70,
    this.focusNode,
    this.borderColor = Colors.white54,
    this.focusedBorderColor = Colors.white,
    this.borderRadius = 10.0,
    this.isFocused = false,
    this.onFieldSubmitted,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TextFormField(
        style: TextStyle(color: textColor, fontSize: 18), // Larger font for TV
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 16, // Larger padding for TV
            horizontal: 12,
          ),
          prefixIcon: prefixIcon==null?null:Icon(prefixIcon, color: iconColor, size: 24), // Larger icon
          labelText: labelText,
          labelStyle: TextStyle(
            color: isFocused ? focusedBorderColor : textColor,
            fontSize: 16, // Larger label
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: isFocused ? focusedBorderColor : borderColor,
              width: isFocused ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: focusedBorderColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }
}