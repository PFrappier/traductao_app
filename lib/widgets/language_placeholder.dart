import 'package:flutter/material.dart';

class LanguagePlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final String? languageName;

  const LanguagePlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.languageName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Center(
        child: languageName != null && languageName!.isNotEmpty
            ? Text(
                languageName!.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: height * 0.4,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : Icon(
                Icons.language,
                size: height * 0.4,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
      ),
    );
  }
}

