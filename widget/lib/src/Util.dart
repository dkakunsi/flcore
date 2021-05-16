library widget;

import 'package:flutter/material.dart';

bool isWebScreen(BuildContext context) =>
    MediaQuery.of(context).size.width > 500;

double getMobileScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width * 0.8;
