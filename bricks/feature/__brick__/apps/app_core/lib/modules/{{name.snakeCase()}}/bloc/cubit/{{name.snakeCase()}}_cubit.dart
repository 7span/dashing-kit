import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';

part '{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Cubit extends Cubit<{{name.pascalCase()}}State> {
  {{name.pascalCase()}}Cubit() : super(const {{name.pascalCase()}}State());
}
