import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class TealButton extends StatelessWidget {
  const TealButton.filled({
    super.key,
    required this.label,
    required this.onPressed,
  }) : isOutlined = false;

  const TealButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
  }) : isOutlined = true;

  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: kAccentPrimary,
            side: const BorderSide(color: kAccentPrimary),
            padding: const EdgeInsets.symmetric(vertical: 14),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: kAccentPrimary,
            foregroundColor: kBgDeep,
            padding: const EdgeInsets.symmetric(vertical: 14),
          );

    final child = Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );

    return SizedBox(
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton(onPressed: onPressed, style: style, child: child)
          : ElevatedButton(onPressed: onPressed, style: style, child: child),
    );
  }
}
