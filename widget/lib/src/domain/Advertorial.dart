library widget;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:api/api.dart';

import '../../Configuration.dart';
import '../Domain.dart';

var api = Api(getConfig());

class Advertorial extends Domain {
  Advertorial() : super('Advertorial', 'This is advertorial');

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
        return GridTile(
            header: GridTileBar(
              title: Text(data[index]['name']),
              backgroundColor: Colors.red,
            ),
            child: InkResponse(
              child: Container(
                padding: EdgeInsets.only(left: 4, top: 60),
                child: Text(data[index]['status']),
              ),
              onTap: () {
                onTap(data[index]['id']);
              },
            ));
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
          "attribute": "status",
          "value": "Pengajuan telah selesai",
          "operator": "equals"
        }
      ]
    };
    return await api.search(context, 'advertorial', criteria);
  }

  @override
  Future<Widget> getInputView(String entityId) async {
    var text = entityId == null ? "null" : entityId;
    return Center(
      child: Text('Advertorial input view: ' + text),
    );
  }

  @override
  FloatingActionButton getGridActionButton(Function onPressed) {
    return FloatingActionButton(
      onPressed: () {
        onPressed(null);
      },
      tooltip: 'Add Advertorial',
      child: Icon(Icons.add),
    );
  }

  @override
  FloatingActionButton getInputActionButton(Function onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Save',
      child: Icon(Icons.save),
    );
  }
}
