library widget;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:api/api.dart';

import '../../Configuration.dart';
import '../Domain.dart';
import '../Util.dart';

var config = Configuration();
var api = Api(config.getConfig());

class Account extends Domain {
  Account() : super('Account', 'This is account');

  @override
  Future<Widget> getDataView(Function onAction) async {
    return AccountGridView(onAction);
  }

  @override
  FloatingActionButton getGridActionButton(Function onPressed) {
    return FloatingActionButton(
      onPressed: () {
        onPressed(null);
      },
      tooltip: 'Add Account',
      child: Icon(Icons.add),
    );
  }

  @override
  Future<Widget> getInputView(String entityId) async {
    return Column(children: [
      Text('Admin input view'),
    ]);
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

class AccountGridView extends StatefulWidget {
  final Function _onAction;

  AccountGridView(this._onAction);

  @override
  State<StatefulWidget> createState() => AccountGridViewState();

  Future<Map> _getGridData() async {
    Map<String, String> context = {
      "token": config.getToken()['id'],
      "breadcrumbId": Uuid().v4()
    };
    var criteria = {"domain": "index", "criteria": []};
    return await api.search(context, 'account', criteria);
  }
}

class AccountGridViewState extends State<AccountGridView> {
  Future<Map> _tasks;

  @override
  void initState() {
    super.initState();
    this._tasks = widget._getGridData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _createGridView(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            return snapshot.hasData
                ? snapshot.data
                : Container(
                    width: 0,
                    height: 0,
                  );
          }),
    );
  }

  Future<Widget> _createGridView() async {
    var result = await _tasks;
    var data = jsonDecode(result['message']);

    var crossAxisCount = 2;
    if (isWebScreen(context)) {
      crossAxisCount = 4;
    }

    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(0.0, 2.0),
              )
            ],
          ),
          padding: EdgeInsets.only(top: 1),
          child: GridTile(
            header: GridTileBar(
              title: Text(data[index]['name']),
              backgroundColor: config.getConfig()['tileColor'],
            ),
            child: InkResponse(
              child: Container(
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 18, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Username: " + data[index]['code'],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 18, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Organisation: " + data[index]['organisation'],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                widget._onAction(data[index]['id']);
              },
            ),
          ),
        );
      },
    );
  }
}
