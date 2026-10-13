import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool compact;
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: compact ? 28 : 56),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
    return compact
        ? Padding(padding: EdgeInsets.all(16), child: content)
        : Center(
            child: Padding(padding: const EdgeInsets.all(24), child: content),
          );
  }
}
