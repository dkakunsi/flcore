import 'package:api/domain/entity/entity.dart';

class ResourceEntity extends Entity {
  ResourceEntity({
    Map<String, dynamic> data,
  }) : super(data: data);

  String get id => getValue('id');

  void set id(String id) => setValue('id', id);

  String get domain => getValue('domain');

  void set domain(String domain) => setValue('domain', domain);

  String get code => getValue('code');

  void set code(String code) => setValue('code', code);

  String get name => getValue('name');

  void set name(String name) => setValue('name', name);
}
