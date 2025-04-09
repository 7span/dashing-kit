import 'dart:async';
import 'dart:developer';

import 'package:api_client/api_client.dart';
import 'package:app_core/modules/{{name.snakeCase()}}/model/{{name.snakeCase()}}_model.dart';
import 'package:app_core/modules/{{name.snakeCase()}}/repository/{{name.snakeCase()}}_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part '{{name.snakeCase()}}_event.dart';
part '{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Bloc extends Bloc<{{name.pascalCase()}}Event, {{name.pascalCase()}}State> {
  {{name.pascalCase()}}Bloc(this.repository) : super(const {{name.pascalCase()}}State()) {
    on<Get{{name.pascalCase()}}Event>(_onGet{{name.pascalCase()}});
    on<Delete{{name.pascalCase()}}Event>(_onDelete{{name.pascalCase()}});

    /// Here, we're using droppable transformer, because it will process
    /// only one event and ignore (drop) any new events until the current event is done.
    on<LoadMore{{name.pascalCase()}}Event>(
      _onLoadMore{{name.pascalCase()}},
      transformer: droppable(),
    );
  }
  final {{name.pascalCase()}}Repository repository;

  /// This parameter is used for the pagination part
  int _page = 1;

  /// When a user clicks on reset filter, we've to reset the [_page] variable to 1
  /// Because we're using this variable directly inside the bloc
  void _resetPage() {
    _page = 1;
  }

  FutureOr<void> _onGet{{name.pascalCase()}}(
    Get{{name.pascalCase()}}Event event,
    Emitter<{{name.pascalCase()}}State> emit,
  ) async {
    _resetPage();

    emit(const {{name.pascalCase()}}State(apiStatus: ApiStatus.loading));
    final fetch{{name.pascalCase()}}DataEither =
        await repository.get{{name.pascalCase()}}Data(1).run();
    fetch{{name.pascalCase()}}DataEither.fold(
      (error) => emit(state.copyWith(apiStatus: ApiStatus.error)),
      (result) {
        _page++;
        emit(
          state.copyWith(
            {{name.camelCase()}}List: result.{{name.camelCase()}}?.data ?? [],
            apiStatus:
                (result.{{name.camelCase()}}?.data?.isNotEmpty ?? false)
                    ? ApiStatus.loaded
                    : ApiStatus.empty,
            hasMorePages:
                (result.{{name.camelCase()}}!.pagination?.hasMorePages ?? true)
                    ? true
                    : false,
          ),
        );
      },
    );
  }

  FutureOr<void> _onLoadMore{{name.pascalCase()}}(
    LoadMore{{name.pascalCase()}}Event event,
    Emitter<{{name.pascalCase()}}State> emit,
  ) async {
    if (!state.hasMorePages) return;

    final fetch{{name.pascalCase()}}DataEither =
        await repository.get{{name.pascalCase()}}Data(_page).run();
    fetch{{name.pascalCase()}}DataEither.fold(
      (error) => emit(state.copyWith(apiStatus: ApiStatus.error)),
      (result) {
        _page++;
        emit(
          state.copyWith(
            apiStatus: ApiStatus.loaded,
            {{name.camelCase()}}List: [
              ...?state.{{name.camelCase()}}List,
              ...?result.{{name.camelCase()}}?.data,
            ],

            hasMorePages:
                (result.{{name.camelCase()}}?.pagination?.hasMorePages ?? true)
                    ? true
                    : false,
          ),
        );
      },
    );
  }

  FutureOr<void> _onDelete{{name.pascalCase()}}(
    Delete{{name.pascalCase()}}Event event,
    Emitter<{{name.pascalCase()}}State> emit,
  ) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    state.{{name.camelCase()}}List?.removeWhere(
      (element) => element.dataId == event.{{name.camelCase()}}Id,
    );

    final new{{name.pascalCase()}}List = state.{{name.camelCase()}}List;

    emit(
      state.copyWith(
        apiStatus: ApiStatus.loaded,
        {{name.camelCase()}}List: new{{name.pascalCase()}}List,
      ),
    );
  }

  @override
  void onChange(Change<{{name.pascalCase()}}State> change) {
    super.onChange(change);
    log('change: $change');
  }
}
