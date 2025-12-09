import 'package:flutter/material.dart';

enum ButtonType { elevated, outline }

class ButtonTypeAction extends StatelessWidget {
  final TextTheme textStyle;
  final ColorScheme color;

  final ButtonType type;
  final String label;
  final VoidCallback? onPressed;

  const ButtonTypeAction({
    super.key,
    required this.type,
    required this.label,
    required this.onPressed,
    required this.textStyle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color.primary,
            elevation: 11,
            shadowColor: color.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: textStyle.titleMedium?.copyWith(color: color.onPrimary),
          ),
        );

      case ButtonType.outline:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: color.primary,
            side: BorderSide(color: color.outlineVariant, width: 1.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: textStyle.titleSmall?.copyWith(
              color: color.onSurfaceVariant,
            ),
          ),
        );
    }
  }
}
