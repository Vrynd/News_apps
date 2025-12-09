import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PasswordFormField extends StatefulWidget {
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
  final Iterable<String>? autofillHints;

  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  const PasswordFormField({
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
    this.autofillHints,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      controller: widget.controller,

      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      textCapitalization: TextCapitalization.none,
      autofillHints: widget.autofillHints,
      autocorrect: false,
      enableSuggestions: false,
      obscureText: _obscureText,

      style: widget.textStyle.bodyLarge?.copyWith(
        color: widget.color.onSurface,
        fontWeight: FontWeight.w500,
      ),

      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,

      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: widget.textStyle.bodyMedium?.copyWith(
          color: widget.color.outline,
        ),
        floatingLabelStyle: widget.textStyle.bodyLarge?.copyWith(
          color: widget.color.primary,
          fontWeight: FontWeight.w600,
        ),
        hintText: widget.hintText,
        hintStyle: widget.textStyle.bodyMedium?.copyWith(
          color: widget.color.outline,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: widget.color.surfaceContainerHigh.withValues(alpha: .8),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.color.primary, width: 1.3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.color.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.color.error, width: 1.3),
        ),

        filled: true,
        fillColor: widget.color.surfaceContainerLow,

        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: widget.prefixIcon,
        ),

        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            icon: Icon(
              _obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
              size: 18,
              color: widget.color.outline,
            ),
          ),
        ),
      ),
    );
  }
}
