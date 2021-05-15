library widget;

import 'package:flutter/material.dart';

import '../Domain.dart';

class Administration extends Domain {
  Administration() : super('Administration', 'This is administration');

  @override
  Future<Widget> getGridView(Function onTap) async {
    return GridView.builder(
      itemCount: 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Text(this.body);
      },
    );
  }

  @override
  Future<Widget> getInputView(String entityId) async {
    return Column(children: [
      Text('Admin input view'),
    ]);
  }
}
