import 'package:fitness_app/gen/assets.gen.dart';
import 'package:fitness_ui/fitness_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// This widget is used inside the [MaterialApp]'s builder property as [ErrorWidget.builder],
/// This widget is the replacement of the static red screen(in development) and
/// grey screen(in production).
///
/// This widget will show errors more neatly to the user and developer thus improving
/// the developer experience.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    required this.details,
    this.onRefresh,
    super.key,
  });

  final Future<void> Function()? onRefresh;
  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) => onRefresh != null
      ? RefreshIndicator(
          onRefresh: onRefresh!,
          child: _ErrorContent(details: details),
        )
      : _ErrorContent(details: details);
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({
    required this.details,
  });

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Builder(
        builder: (context) {
          final errorColor = context.colorScheme.error;
          // final primaryColor = context.colorScheme.foreground;
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(Insets.medium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.errorIllustration.image(),
                  Text(
                    kDebugMode ? details.summary.toString() : 'Oups! Something went wrong!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kDebugMode ? errorColor : primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    kDebugMode
                        ? 'https://docs.flutter.dev/testing/errors'
                        : "We encountered an error and we've notified our engineering team about it. Sorry for the inconvenience caused.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
