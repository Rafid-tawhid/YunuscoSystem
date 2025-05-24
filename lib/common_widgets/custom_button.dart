import 'package:flutter/material.dart';
import 'package:yunusco_group/utils/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? borderRadius;
  final Widget? icon;
  final double? elevation;
  final bool isFullWidth;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.verticalPadding,
    this.horizontalPadding,
    this.borderRadius,
    this.icon,
    this.elevation,
    this.isFullWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? myColors.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 16.0,
            horizontal: horizontalPadding ?? 24.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          ),
          elevation: elevation ?? 2.0,
        ),
        child: isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              textColor ?? Colors.white,
            ),
          ),
        )
            : icon != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!,
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: textColor ?? Colors.white,
              ),
            ),
          ],
        )
            : Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}