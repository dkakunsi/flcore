library widget;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:api/api.dart';
import 'package:widget/src/component/DataPage.dart';

import '../Domain.dart';
import '../Util.dart';
import '../component/InputField.dart';
import '../../Configuration.dart';

var config = Configuration();
var api = Api(config.getConfig());

class Account extends Domain {
  _AccountInputView _accountInputView;

  Account() : super('Account', 'This is account');

  @override
  SearchableWidget getDataView(Function onAction) {
    return _AccountGridView(onAction);
  }

  @override
  FloatingActionButton getGridActionButton(Function onPressed) {
    return FloatingActionButton(
      backgroundColor: config.getConfig()['primaryColor'],
      hoverColor: config.getConfig()['focusColor'],
      elevation: 10,
      onPressed: () {
        onPressed(null);
      },
      tooltip: 'Add Account',
      child: Icon(Icons.add),
    );
  }

  @override
  Widget getInputView(String entityId) =>
      this._accountInputView = _AccountInputView(entityId);

  @override
  FloatingActionButton getInputActionButton(Function onPressed) {
    return FloatingActionButton(
      backgroundColor: config.getConfig()['primaryColor'],
      hoverColor: config.getConfig()['focusColor'],
      elevation: 10,
      onPressed: () {
        this._accountInputView.save().then((value) {
          print(jsonEncode(value));
        }).onError((error, stackTrace) {
          print(error);
        }).whenComplete(() {
          onPressed();
        });
      },
      tooltip: 'Save',
      child: Icon(Icons.save),
    );
  }
}

class _AccountGridView extends SearchableWidget {
  final _AccountGridViewState _state = _AccountGridViewState();

  final Function _onAction;

  _AccountGridView(this._onAction);

  @override
  State<StatefulWidget> createState() => this._state;

  Future<Map> _getGridData() async {
    var criteria = {
      "domain": "index",
      "page": 0,
      "size": 50,
      "criteria": [],
    };
    return await _load(criteria);
  }

  @override
  void search(String value) {
    var criteria = {
      "domain": "index",
      "page": 0,
      "size": 50,
      "criteria": [
        {"attribute": "name", "value": value, "operator": "contains"}
      ],
    };
    var result = _load(criteria);
    this._state.setAccounts(result);
  }

  Future<Map> _load(Map criteria) async {
    Map<String, String> context = {
      "token": config.getToken()['id'],
      "breadcrumbId": Uuid().v4()
    };
    return await api.search(context, 'account', criteria);
  }
}

class _AccountGridViewState extends State<_AccountGridView> {
  Future<Map> _accounts;

  @override
  void initState() {
    super.initState();
    this._accounts = widget._getGridData();
  }

  void setAccounts(Future<Map> accounts) {
    setState(() {
      this._accounts = accounts;
    });
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
    var result = await _accounts;
    var data = jsonDecode(result['message']);
    var crossAxisCount = gridCount(context);

    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: getGridAspectRation(context),
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

class _AccountInputView extends StatefulWidget {
  final String _id;

  final Map<String, Map<String, dynamic>> _attributes = {
    'code': {'title': 'Username', 'icon': Icons.code},
    'name': {'title': 'Name', 'icon': Icons.tag},
    'email': {'title': 'Email', 'icon': Icons.alternate_email_rounded},
    'password': {'title': 'Password', 'icon': Icons.vpn_key},
    'organisation': {'title': 'Organisation', 'icon': Icons.build},
    'role': {'title': 'Role', 'icon': Icons.perm_device_info}
  };

  final List<InputField> _inputFields = [];

  final Map _data = {'account': {}};

  _AccountInputView(this._id) {
    this._attributes.forEach((key, detail) {
      var name = detail['title'];
      var icon = detail['icon'];
      this._inputFields.add(InputField(key, name, icon));
    });
  }

  @override
  State<StatefulWidget> createState() => _AccountInputViewState();

  Future<Map> _getDetailData() async {
    if (this._id == null) {
      return {};
    }

    Map<String, String> context = {
      "token": config.getToken()['id'],
      "breadcrumbId": Uuid().v4()
    };
    return await api.getResource(context, 'account', this._id);
  }

  Future<Map> save() async {
    Map payload = this._data['account'];
    this._inputFields.forEach((inputField) {
      dynamic value = inputField.controller.text;
      if (inputField.elementId == 'role') {
        value = getRoles(value);
      }
      setJSONValue(payload, inputField.elementId, value);
    });

    setJSONValue(payload, 'domain', 'account');

    payload.remove('createdDate');
    payload.remove('lastUpdatedDate');

    Map<String, String> context = {
      "token": config.getToken()['id'],
      "breadcrumbId": Uuid().v4()
    };

    if (payload['id'] == null) {
      // create using workflow
      return Future.delayed(
        Duration(seconds: 2),
        () => api.postResource(context, 'account', payload),
      );
    } else {
      // update using resource
      return Future.delayed(
        Duration(seconds: 2),
        () => api.putResource(context, 'advertorial', payload['id'], payload),
      );
    }
  }

  List getRoles(role) {
    if (!role.contains(',')) {
      return [role];
    }

    var roles = [];
    role.split(',').forEach((element) {
      roles.add(element);
    });
    return roles;
  }
}

class _AccountInputViewState extends State<_AccountInputView> {
  Future<Map> _account;

  @override
  void initState() {
    super.initState();
    this._account = widget._getDetailData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _createInputView(),
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

  Future<Widget> _createInputView() async {
    var result = await this._account;
    if (result.isNotEmpty) {
      widget._data['account'] = jsonDecode(result['message']);

      widget._inputFields.forEach((inputField) {
        var value = getJSONValue(widget._data['account'], inputField.elementId);
        if (inputField.elementId == 'role') {
          value = getRoles(value);
        }
        inputField.controller.text = value;
      });
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: widget._inputFields,
        ),
      ),
    );
  }

  String getRoles(List roles) {
    var result = '';
    roles.forEach((role) {
      if (result == '') {
        result = role;
      } else {
        result += ',' + role;
      }
    });
    return result;
  }
}
