import 'package:flutter/material.dart';
import 'package:apps/pages/login.dart';
import 'package:apps/pages/load_login.dart';
import 'package:apps/pages/home.dart';
import 'package:apps/pages/item.dart';
import 'package:apps/pages/history.dart';
import 'package:apps/pages/add_item.dart';
import 'package:apps/pages/ship.dart';
import 'package:apps/pages/box_status.dart';

void main()=> runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/':(context) => MyCustomForm(),
    '/home':(context) => Home(),
    '/load_login':(context) => LoadLogin(),
    '/item':(context) => Item(),
    '/history':(context) => History(),
    '/add_item':(context) => AddItem(),
      '/ship':(context) => Ship(),
    '/view_details': (context) => BoxStatus()

  }
));

