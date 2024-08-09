import 'package:app_core/app/helpers/injection.dart';
import 'package:logger/logger.dart';

void flog(String message) {
  getIt<Logger>().i(message);
}
