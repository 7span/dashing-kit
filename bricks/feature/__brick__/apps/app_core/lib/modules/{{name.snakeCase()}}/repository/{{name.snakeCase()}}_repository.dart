import 'package:api_client/api_client.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class I{{name.pascalCase()}}Repository {
  TaskEither<Failure, Unit> make{{name.pascalCase()}}DetailsApi();
}

class {{name.pascalCase()}}Repository implements I{{name.pascalCase()}}Repository {
  @override
  TaskEither<Failure, Unit> make{{name.pascalCase()}}DetailsApi() {
    // TODO: implement makeMeowDetailsApi
    throw UnimplementedError();
  }
}
