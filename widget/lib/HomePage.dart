library widget;

import 'dart:developer';

import 'package:flutter/material.dart';

import 'src/Domain.dart';
import 'Configuration.dart';

var config = Configuration();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _action = 'gridView';

  List<Widget> _drawerWidgets;

  Map<String, Domain> _domains;

  Domain _selectedDomain;

  String _entityId;

  Function _viewAction;

  @override
  void initState() {
    super.initState();
    this._entityId = null;
    this._domains = getDomains(config.getToken()['role']);
    this._selectedDomain = this._domains.values.elementAt(0);
    this._drawerWidgets = getDrawerWidgets(this._domains);

    this._viewAction = this._selectedDomain.name == 'Login'
        ? this._setLogin
        : this._openInputView;
  }

  List<Widget> getDrawerWidgets(Map<String, Domain> domains) {
    List<Widget> widgets = [
      DrawerHeader(
          decoration: BoxDecoration(color: Colors.white),
          child: Image(image: AssetImage('logo.png'))),
    ];

    domains.forEach((key, domain) {
      widgets.add(domain.getListTile(_selectDomain));
    });

    return widgets;
  }

  void _selectDomain(String domain) {
    setState(() {
      this._action = 'gridView';
      this._selectedDomain = this._domains[domain];
    });
    Navigator.pop(context);
  }

  void _openInputView(String entityId) {
    setState(() {
      this._action = 'inputView';
      this._entityId = entityId;
    });
  }

  void _openGridView() {
    setState(() {
      this._action = 'gridView';
      this._entityId = null;
    });
  }

  void _setLogin() {
    setState(() {
      this._domains = getDomains(config.getToken()['role']);
      this._selectedDomain = this._domains.values.elementAt(0);
      this._drawerWidgets = getDrawerWidgets(this._domains);

      this._viewAction = this._selectedDomain.name == 'Login'
          ? this._setLogin
          : this._openInputView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this._selectedDomain.name,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: FutureBuilder(
            future: this._action == 'gridView'
                ? this._selectedDomain.getDataView(this._viewAction)
                : this._selectedDomain.getInputView(this._entityId),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              return snapshot.hasData
                  ? snapshot.data
                  : this._selectedDomain.defaultBody;
            }),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: this._drawerWidgets,
        ),
      ),
      floatingActionButton: this._action == 'gridView'
          ? this._selectedDomain.getGridActionButton(_openInputView)
          : config.isAdmin()
              ? this._selectedDomain.getInputActionButton(_openGridView)
              : null,
    );
  }
}
