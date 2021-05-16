library widget;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:api/api.dart';

import '../Domain.dart';
import '../Util.dart';
import '../component/InputField.dart';
import '../../Configuration.dart';

var config = Configuration();
var api = Api(config.getConfig());

class Task extends Domain {
  TaskInputView _taskInputView;

  Task() : super('Task', 'This is task');

  @override
  Future<Widget> getDataView(Function onAction) async {
    return TaskGridView(onAction);
  }

  @override
  Future<Widget> getInputView(String entityId) async =>
      this._taskInputView = TaskInputView(entityId);

  @override
  FloatingActionButton getInputActionButton(Function onPressed) {
    return FloatingActionButton(
      onPressed: () {
        this._taskInputView.save().then((value) {
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

class TaskGridView extends StatefulWidget {
  final Function _onAction;

  TaskGridView(this._onAction);

  @override
  State<StatefulWidget> createState() => TaskGridViewState();

  Future<Map> _getGridData() async {
    Map<String, String> context = {
      "token": config.getToken()['id'],
      "breadcrumbId": Uuid().v4()
    };
    var criteria = {
      "domain": "index",
      "page": 0,
      "size": 10,
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
}

class TaskGridViewState extends State<TaskGridView> {
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
              title: Text(data[index]['processInstanceId']),
              backgroundColor: config.getConfig()['tileColor'],
            ),
            child: InkResponse(
              child: Container(
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 18, top: 10, right: 4),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Task: " + data[index]['name'],
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

class TaskInputView extends StatefulWidget {
  final String _id;

  final Map<String, String> _attributes = {
    'name': 'name',
    'approved': 'approval',
    'closedReason': 'reason',
  };

  final List<InputField> _inputFields = [];

  final Map _data = {'task': {}};

  TaskInputView(this._id) {
    this._attributes.forEach((key, name) {
      this._inputFields.add(InputField(key, name));
    });
  }

  @override
  State<StatefulWidget> createState() => TaskInputViewState();

  Future<Map> _getDetailData() async {
    if (this._id == null) {
      return {};
    }

    Map<String, String> context = {
      "token": config.getToken()['id'],
      "breadcrumbId": Uuid().v4()
    };
    var criteria = {
      "domain": "index",
      "page": 0,
      "size": 1,
      "criteria": [
        {
          "attribute": "id",
          "value": this._id,
          "operator": "equals",
        }
      ]
    };
    return await api.search(context, 'workflowtask', criteria);
  }

  Future<Map> save() async {
    Map payload = this._data['task'];
    this._inputFields.forEach((inputField) {
      var value = inputField.controller.text;
      setJSONValue(payload, inputField.elementId, value);
    });

    Map<String, String> context = {
      "token": config.getToken()['id'],
      "breadcrumbId": Uuid().v4()
    };

    if (payload['approved'] == 'true') {
      return Future.delayed(
        Duration(seconds: 1),
        () => api.approveTask(context, this._id),
      );
    } else if (payload['approved'] == 'false') {
      return Future.delayed(
        Duration(seconds: 1),
        () => api.rejectTask(context, this._id, payload['closedReason']),
      );
    } else {
      throw ('Approval response is not recognized: ' + payload['approved']);
    }
  }
}

class TaskInputViewState extends State<TaskInputView> {
  Future<Map> _task;

  @override
  void initState() {
    super.initState();
    this._task = widget._getDetailData();
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
    var result = await this._task;
    if (result.isNotEmpty) {
      widget._data['task'] = jsonDecode(result['message'])[0];

      widget._inputFields.forEach((inputField) {
        var value = getJSONValue(widget._data['task'], inputField.elementId);
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
