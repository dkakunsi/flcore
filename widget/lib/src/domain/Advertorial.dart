library widget;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:api/api.dart';

import '../Domain.dart';
import '../Util.dart';
import '../component/InputField.dart';
import '../../Configuration.dart';

var config = Configuration();
var api = Api(config.getConfig());

class Advertorial extends Domain {
  _AdvertorialInputView _advertorialInputView;

  Advertorial() : super('Advertorial', 'This is advertorial');

  @override
  Future<Widget> getDataView(Function onAction) async {
    return AdvertorialGridView(onAction);
  }

  @override
  Future<Widget> getInputView(String entityId) async =>
      this._advertorialInputView = _AdvertorialInputView(entityId);

  @override
  FloatingActionButton getGridActionButton(Function onPressed) {
    return FloatingActionButton(
      backgroundColor: config.getConfig()['primaryColor'],
      hoverColor: config.getConfig()['focusColor'],
      elevation: 10,
      onPressed: () {
        onPressed(null);
      },
      tooltip: 'Add Advertorial',
      child: Icon(Icons.add),
    );
  }

  @override
  FloatingActionButton getInputActionButton(Function onPressed) {
    if (this._advertorialInputView._id != null && !config.isAdmin()) {
      return null;
    }

    return FloatingActionButton(
      backgroundColor: config.getConfig()['primaryColor'],
      hoverColor: config.getConfig()['focusColor'],
      elevation: 10,
      onPressed: () {
        this._advertorialInputView.save().then((value) {
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

class AdvertorialGridView extends StatefulWidget {
  final Function _onAction;

  AdvertorialGridView(this._onAction);

  @override
  State<StatefulWidget> createState() => AdvertorialGridViewState();

  Future<Map> _getGridData() async {
    Map<String, String> context = {
      "token": config.getToken()['id'],
      "breadcrumbId": Uuid().v4()
    };
    var criteria = {
      "domain": "index",
      "page": 0,
      "size": 50,
      "criteria": [],
    };
    return await api.search(context, 'advertorial', criteria);
  }
}

class AdvertorialGridViewState extends State<AdvertorialGridView> {
  Future<Map> _advertorials;

  @override
  void initState() {
    super.initState();
    this._advertorials = widget._getGridData();
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
    var result = await _advertorials;
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
              title: Text(data[index]['code']),
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
                          "Name: " + data[index]['name'],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 18, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Status: " + data[index]['status'],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 18, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Provider: " + (data[index]['provider']['name']),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 18, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Created At: " +
                              toDateTime(data[index]['createdDate']),
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

class _AdvertorialInputView extends StatefulWidget {
  final String _id;

  final Map<String, Map<String, dynamic>> _attributes = {
    'code': {'title': 'Code', 'icon': Icons.code},
    'name': {'title': 'Title', 'icon': Icons.assignment},
    'url': {'title': 'Url', 'icon': Icons.public},
    'provider_name': {'title': 'Provider name', 'icon': Icons.account_circle},
    'provider_email': {'title': 'Provider email', 'icon': Icons.alternate_email}
  };

  final List<InputField> _inputFields = [];

  final Map _data = {'advert': {}};

  _AdvertorialInputView(this._id) {
    this._attributes.forEach((key, detail) {
      var name = detail['title'];
      var icon = detail['icon'];
      this._inputFields.add(InputField(key, name, icon));
    });
  }

  @override
  State<StatefulWidget> createState() => _AdvertorialInputViewState();

  Future<Map> _getDetailData() async {
    if (this._id == null) {
      return {};
    }

    Map<String, String> context = {
      "token": config.getToken()['id'],
      "breadcrumbId": Uuid().v4()
    };
    return await api.getResource(context, 'advertorial', this._id);
  }

  Future<Map> save() async {
    Map payload = this._data['advert'];
    this._inputFields.forEach((inputField) {
      var value = inputField.controller.text;
      setJSONValue(payload, inputField.elementId, value);
    });

    setJSONValue(payload, 'domain', 'advertorial');

    payload.remove('createdDate');
    payload.remove('lastUpdatedDate');

    Map<String, String> context = {
      "token": config.getToken()['id'],
      "breadcrumbId": Uuid().v4()
    };

    if (payload['id'] == null) {
      // create using workflow

      payload['status'] = 'Pengajuan telah terdaftar';

      var jsonData = {
        'domain': 'workflow',
        'action': 'advertorial.submit',
        'entity': payload,
        'variable': {'organisation': 'PDE'}
      };
      return Future.delayed(
        Duration(seconds: 2),
        () => api.createInstance(context, jsonData),
      );
    } else {
      // update using resource
      return Future.delayed(
        Duration(seconds: 2),
        () => api.putResource(context, 'advertorial', payload['id'], payload),
      );
    }
  }
}

class _AdvertorialInputViewState extends State<_AdvertorialInputView> {
  Future<Map> _advertorial;

  @override
  void initState() {
    super.initState();
    this._advertorial = widget._getDetailData();
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
    var result = await this._advertorial;
    if (result.isNotEmpty) {
      widget._data['advert'] = jsonDecode(result['message']);

      widget._inputFields.forEach((inputField) {
        var value = getJSONValue(widget._data['advert'], inputField.elementId);
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
}
