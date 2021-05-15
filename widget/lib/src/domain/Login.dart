library widget;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:api/api.dart';

import '../Domain.dart';
import '../../Configuration.dart';

var config = Configuration();
var api = Api(config.getConfig());

class Login extends Domain {
  Login() : super('Login', 'This is login');

  @override
  Future<Widget> getDataView(Function onLogin) async {
    return LoginDataView(onLogin);
  }

  @override
  Future<Widget> getInputView(String entityId) async {
    return Column(children: [
      Text('Login input view'),
    ]);
  }
}

class LoginDataView extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final Function _onLogin;

  LoginDataView(this._onLogin);

  @override
  Widget build(BuildContext context) {
    bool isWebScreen = MediaQuery.of(context).size.width > 500;
    var mobileScreenWidth = MediaQuery.of(context).size.width * 0.8;

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: config.getConfig()['primaryColor'],
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 3,
                      ),
                      child: Hero(
                        tag: 'hero-login',
                        child: Image(
                          image: AssetImage('logo.png'),
                          width: isWebScreen ? 200 : 100,
                          height: isWebScreen ? 200 : 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: isWebScreen
                ? MediaQuery.of(context).size.height * 0.5
                : MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              color: config.getConfig()['secondaryColor'],
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(50.0),
                topRight: const Radius.circular(50.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  width: isWebScreen ? 360 : mobileScreenWidth,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.account_circle,
                              color: Colors.grey, size: 30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: config.getConfig()['secondaryColor'],
                        focusColor: config.getConfig()['focusColor'],
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: config.getConfig()['focusColor']),
                        ),
                        hintText: 'Enter username',
                      ),
                      controller: this._usernameController,
                    ),
                  ),
                ),
                Container(
                  width: isWebScreen ? 360 : mobileScreenWidth,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.vpn_key_rounded,
                              color: Colors.grey, size: 30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: config.getConfig()['secondaryColor'],
                        focusColor: config.getConfig()['focusColor'],
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: config.getConfig()['focusColor']),
                        ),
                        hintText: 'Enter password',
                      ),
                      controller: this._passwordController,
                    ),
                  ),
                ),
                Container(
                  width: isWebScreen ? 360 : mobileScreenWidth,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, right: 40, left: 40),
                    child: ElevatedButton(
                      onPressed: _sendAuthentication,
                      child: Text('Login',
                          style: TextStyle(
                            fontSize: 14,
                            color: config.getConfig()['secondaryColor'],
                          )),
                      style: ElevatedButton.styleFrom(
                        primary: config.getConfig()['primaryColor'],
                        onPrimary: config.getConfig()['secondaryColor'],
                        minimumSize: Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _sendAuthentication() {
    var username = this._usernameController.text;
    var password = this._passwordController.text;
    var breadcrumbId = Uuid().v4();

    var future = api.login(breadcrumbId, username, password);

    future.then((value) {
      var token = jsonDecode(value['message']);
      config.setToken(token);
      this._onLogin();
    });
  }
}
