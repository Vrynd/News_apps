import 'package:flutter/material.dart';

class EmailFormField extends StatelessWidget {
  final TextTheme textStyle;
  final ColorScheme color;

  final bool autofocus;
  final FocusNode focusNode;
  final TextEditingController controller;

  final String labelText;
  final String hintText;
  final Widget prefixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final bool autocorrect;
  final bool enableSuggestions;

  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  const EmailFormField({
    super.key,
    this.autofocus = false,
    required this.focusNode,
    required this.controller,
    required this.textStyle,
    required this.color,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      autofillHints: autofillHints,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,

      style: textStyle.bodyLarge?.copyWith(
        color: color.onSurface,
        fontWeight: FontWeight.w500,
      ),

      validator: validator,
      onFieldSubmitted: onFieldSubmitted,

      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: textStyle.bodyMedium?.copyWith(color: color.outline),
        floatingLabelStyle: textStyle.bodyLarge?.copyWith(
          color: color.primary,
          fontWeight: FontWeight.w600,
        ),
        hintText: hintText,
        hintStyle: textStyle.bodyMedium?.copyWith(color: color.outline),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: color.surfaceContainerHigh.withValues(alpha: .8),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color.primary, width: 1.3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color.error, width: 1.3),
        ),

        filled: true,
        fillColor: color.surfaceContainerLow,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: prefixIcon,
        ),
      ),
    );
  }
}
