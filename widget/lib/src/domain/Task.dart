library widget;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:api/api.dart';

import '../../Configuration.dart';
import '../Domain.dart';

var api = Api(getConfig());

class Task extends Domain {
  Task() : super('Task', 'This is task');

  @override
  Future<GridView> getGridView(Function onTap) async {
    var result = await _getGridData();
    var data = jsonDecode(result['message']);

    return GridView.builder(
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Text(data[index]['name']);
      },
    );
  }

  Future<Map> _getGridData() async {
    Map<String, String> context = {
      "token": getToken()['id'],
      "breadcrumbId": Uuid().v4()
    };
    var criteria = {
      "domain": "index",
      "criteria": [
        {
          "attribute": "organisation",
          "value": "PDE",
          "operator": "equals",
        },
        {
          "attribute": "status",
          "value": "Active",
          "operator": "equals",
        }
      ]
    };
    return await api.search(context, 'workflowtask', criteria);
  }

  @override
  Future<Widget> getInputView(String entityId) async {
    return Column(children: [
      Text('Task input view: ' + entityId),
    ]);
  }
}
