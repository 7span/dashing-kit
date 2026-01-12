import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'Slide & Fade Animation',
  type: SlideAndFadeAnimationWrapper,
)
Widget slideAndFadeAnimationWrapperUseCase(BuildContext context) {
  final knobs = context.knobs;

  final slideDirection = knobs.object.dropdown<SlideFrom>(
    label: 'Slide From',
    options: SlideFrom.values,
    initialOption: SlideFrom.bottom,
  );

  final delay = knobs.int.slider(
    label: 'Delay (ms)',
    initialValue: 700,
    min: 0,
    max: 2000,
    divisions: 20,
  );

  final isLoading = knobs.boolean(
    label: 'Is Loading',
    initialValue: false,
  );

  return AppScaffold(
    body: Center(
      child: SlideAndFadeAnimationWrapper(
        delay: delay,
        isLoading: isLoading,
        slideFrom: slideDirection,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            'Slide & Fade In',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    ),
  );
}
