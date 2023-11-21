import 'package:fitness_app/app/helpers/injection.dart';
import 'package:logger/logger.dart';

void flog(String message) {
  getIt<Logger>().i(message);
}
