import 'package:bloc_boilerplate/app/app.dart';
import 'package:bloc_boilerplate/app/enum.dart';
import 'package:bloc_boilerplate/bootstrap.dart';

void main() {
  bootstrap(App.new, Env.production);
}
