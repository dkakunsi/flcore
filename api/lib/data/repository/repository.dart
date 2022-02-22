import 'package:logging/logging.dart';

abstract class Repository {
  Logger log;

  Repository({String name}) {
    log = Logger(name);
  }
}

class RepositoryException implements Exception {
  final String message;

  RepositoryException({this.message});
}
