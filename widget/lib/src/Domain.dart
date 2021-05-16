library widget;

import 'package:flutter/material.dart';

import 'domain/Account.dart';
import 'domain/Advertorial.dart';
import 'domain/Login.dart';
import 'domain/Task.dart';

abstract class Domain {
  final String name;

  final String body;

  final Widget defaultBody = GridView(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
    ),
  );

  Domain(this.name, this.body);

  ListTile getListTile(Function onTap) {
    return ListTile(
        title: Text(this.name),
        onTap: () {
          onTap(this.name);
        });
  }

  Future<Widget> getDataView(Function onTap);

  FloatingActionButton getGridActionButton(Function onPressed) {
    return null;
  }

  Future<Widget> getInputView(String entityId);

  FloatingActionButton getInputActionButton(Function onPressed) {
    return null;
  }
}

Map<String, Domain> getDomains(List roles) {
  if (roles == null || roles.isEmpty) {
    return {'Login': Login()};
  }

  Map<String, Domain> domains = {
    'Advertorial': Advertorial(),
    'Task': Task(),
  };
  if (roles.contains('admin')) {
    domains.putIfAbsent('Account', () => Account());
  }
  return domains;
}
