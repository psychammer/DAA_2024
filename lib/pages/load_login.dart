import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadLogin extends StatefulWidget {
  const LoadLogin({super.key});

  @override
  State<LoadLogin> createState() => _LoadLoginState();
}

class _LoadLoginState extends State<LoadLogin> {
  Map data = {};

  String time = 'loading';

  void loadHomePage(email, password) async {
    Response response = await get(Uri.parse('http://192.168.0.15/login?Query=${email}&Query2=${password}'));
    Map auth = jsonDecode(response.body);
    if(auth['user_matched']==true){
      Navigator.pushReplacementNamed(context, '/home');
    }
    else{
      Navigator.pop(context, true);
    }
  }


  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty? data : ModalRoute.of(context)?.settings?.arguments as Map;
    loadHomePage(data['email'], data['password']);
    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: Center(
          child: SpinKitFoldingCube(
            color: Colors.yellowAccent,
            size: 50.0,
          ),
        )
    );
  }
}
