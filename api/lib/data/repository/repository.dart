abstract class Repository {}

class RepositoryException implements Exception {
  final String message;

  RepositoryException({this.message});
}
