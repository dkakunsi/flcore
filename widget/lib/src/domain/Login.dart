library widget;

import 'package:flutter/material.dart';

import '../Domain.dart';

class Login extends Domain {
  Login() : super('Login', 'This is login');

  @override
  Future<Center> getGridView(Function onTap) async {
    return Center(child: Text('Please login'),);
  }

  @override
  Future<Widget> getInputView(String entityId) async {
    return Column(children: [
      Text('Login input view'),
    ]);
  }
}
