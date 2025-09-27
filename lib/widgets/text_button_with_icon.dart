import 'package:flutter/material.dart';

class TextButtonWithIcon extends StatelessWidget {
  const TextButtonWithIcon({
    super.key,
    required this.text,
    required this.icon,
    required this.outlined,
    required this.onPressed,
  });

  final Icon icon;
  final String text;
  final bool outlined;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: outlined
              ? OutlinedButton.icon(
                  onPressed: onPressed,
                  icon: icon,
                  label: Text(text),
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                    const EdgeInsets.all(15.0),
                  )),
                )
              : FilledButton.icon(
                  label: Text(text),
                  icon: icon,
                  onPressed: onPressed,
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                    const EdgeInsets.all(15.0),
                  )),
                ),
        ),
      ],
    );
  }
}
