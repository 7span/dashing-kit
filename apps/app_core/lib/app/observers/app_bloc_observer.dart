import 'package:app_core/app/helpers/injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// This class is used for printing the logs for changing the states and events that
/// are happening inside the BloC.
///
/// Whenever a user adds any event or emits any state, this class will trigger the
/// [onChange] function that keeps printing the state and event at that particular time.
final class AppBlocObserver extends BlocObserver {
  Logger logger = getIt<Logger>();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      logger
      // ignore: avoid_dynamic_calls
      .f(
        'onChange(${bloc.runtimeType}, ${change.nextState.runtimeType})',
      );
    }
  }

  @override
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    if (kDebugMode) {
      logger.e('onError(${bloc.runtimeType}, $error, $stackTrace)');
    }
    super.onError(bloc, error, stackTrace);
  }
}
