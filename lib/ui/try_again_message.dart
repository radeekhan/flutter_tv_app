import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../resources/krs_locale.dart';

class TryAgainMessage extends StatelessWidget {
  final Function() onRetry;

  const TryAgainMessage({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = KrsLocale.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: Icon(Icons.live_tv_outlined,
              size: 128.0,
              color: theme.colorScheme.outline.withOpacity(0.36),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(locale.errorLoadingVideo),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: FilledButton.tonal(
              autofocus: true,
              onPressed: () {
                onRetry();
              },
              child: Text(locale.tryAgain),
            ),
          ),

          FilledButton.tonal(
            onPressed: () {
              context.pop();
            },
            child: Text(locale.back),
          ),

        ],
      ),
    );
  }
}