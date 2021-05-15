library widget;

import 'package:flutter/material.dart';

import 'src/Domain.dart';
import 'Configuration.dart';

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

  @override
  void initState() {
    super.initState();

    this._entityId = null;
    this._domains = getDomains(token['role']);
    this._selectedDomain = this._domains.values.elementAt(0);
    this._drawerWidgets = getDrawerWidgets(this._domains);
  }

  List<Widget> getDrawerWidgets(Map<String, Domain> domains) {
    List<Widget> widgets = [
      DrawerHeader(
          decoration: BoxDecoration(color: Colors.white),
          child: Image(image: AssetImage('logo_sangihekab.png'))),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._selectedDomain.name),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: FutureBuilder(
            future: this._action == 'gridView'
                ? this._selectedDomain.getGridView(_openInputView)
                : this._selectedDomain.getInputView(this._entityId),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              return snapshot.hasData
                  ? snapshot.data
                  : this._selectedDomain.defaultBody;
            }),
      ),
      drawer: Drawer(
        child:
            ListView(padding: EdgeInsets.zero, children: this._drawerWidgets),
      ),
      floatingActionButton: this._action == 'gridView'
          ? this._selectedDomain.getGridActionButton(_openInputView)
          : this._selectedDomain.getInputActionButton(_openGridView),
    );
  }
}
