import 'package:uuid/uuid.dart';

const BREADCRUMB_ID = 'breadcrumbId';

class Context {
  Map<String, dynamic> _data;

  Context() {
    _data = {
      BREADCRUMB_ID: _getUuid(),
    };
  }

  static String _getUuid() => Uuid().v1().toString();

  String get breadcrumbId => _data[BREADCRUMB_ID];

  Map<String, dynamic> toHeader() => _data;

  void addEntry(String key, dynamic value) {
    _data.putIfAbsent(key, () => value);
  }
}
