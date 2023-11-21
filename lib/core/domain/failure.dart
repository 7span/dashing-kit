/// Here, we're creating an abstract class for Faliure, Because
/// We can swap any kind of implementation that we want while
/// passing the Sub Failure class or while testing
sealed class Failure {
  Failure();
  String get message;
}

/// This failure represents that there's some issue
/// in either calling an API or while there's something
/// happened on the backend side
class APIFailure extends Failure {
  APIFailure({this.error, this.stackTrace});
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String get message => "There' a issue in the API";
}

/// This failure represents that there's some problem in parsing the
/// json data into dart model
class ModelConversionFailure extends Failure {
  ModelConversionFailure({this.error, this.stackTrace});
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String get message => 'The API data could not be parsed into the model';
}

/// This failure represents that there's some problem in parsing the
/// json data from the API
class JsonParsingFailure extends Failure {
  JsonParsingFailure({this.error, this.stackTrace});
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String get message => 'The JSON data could not be parsed';
}

/// This failure is used when we're not able to write the userdata into the database
class UserSaveFailure extends Failure {
  UserSaveFailure({
    this.error,
    this.stackTrace,
  });
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String get message => "There's an issue in saving the data";
}

class UserTokenSaveFailure extends Failure {
  UserTokenSaveFailure({
    this.error,
    this.stackTrace,
  });
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String get message => "There's an issue in saving the token";
}
