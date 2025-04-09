part of '{{name.snakeCase()}}_bloc.dart';

@immutable
sealed class {{name.pascalCase()}}Event extends Equatable {
  const {{name.pascalCase()}}Event();
}

class Get{{name.pascalCase()}}Event extends {{name.pascalCase()}}Event {
  const Get{{name.pascalCase()}}Event();

  @override
  List<Object?> get props => [];
}

class LoadMore{{name.pascalCase()}}Event extends {{name.pascalCase()}}Event {
  const LoadMore{{name.pascalCase()}}Event();

  @override
  List<Object?> get props => [];
}

class Delete{{name.pascalCase()}}Event extends {{name.pascalCase()}}Event {
  final int {{name.camelCase()}}Id;

  const Delete{{name.pascalCase()}}Event({required this.{{name.camelCase()}}Id});

  @override
  List<Object?> get props => [{{name.camelCase()}}Id];
}
