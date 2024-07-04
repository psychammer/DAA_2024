import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:apps/API.dart';
import 'dart:convert';
import 'package:http/http.dart';


class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {

  TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 20.0);
  TextStyle linkStyle = TextStyle(color: Colors.blue);

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  bool _passwordVisible = true;
  bool _showError = false;

  Future<bool> _submit() async{
    dynamic result = await Navigator.pushNamed(context, '/load_login', arguments: {'email': _controller1.text, 'password': _controller2.text});

    return result;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Image.asset('assets/ikea.png')
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Text(
                    'Welcome Back !',
                    style: TextStyle(
                        fontSize:30,
                        fontFamily: 'Inter-Black'
                    )
                )
            ),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                child: Text(
                    'Enter your credential to login',
                    style: TextStyle(
                        fontSize:15,
                        fontFamily: 'Inter-Black'
                    )
                )
            ),

            SizedBox(
              height: 60,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Material(
                color: Colors.transparent,
                elevation: 20.0,
                shadowColor: Colors.blue,
                child: TextFormField(
                  controller: _controller1,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Image.asset('assets/E-mail.png', width: 30, height: 30)
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'E-Mail',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Material(
                color: Colors.transparent,
                elevation: 20.0,
                shadowColor: Colors.blue,
                child:TextFormField(
                    controller: _controller2,
                    obscureText: _passwordVisible ,
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image.asset('assets/Password.png', width: 30, height: 30)
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Enter your Password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )
                    )
                ),
              ),
            ),

            Visibility(visible: _showError,
                       child: Text("Username or Password Incorrect",
                                    style: TextStyle(color: Colors.red, fontFamily: 'Inter-Black'))
            ),


            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                child: IconButton(
                  icon: Image.asset('assets/Login_button.png'),
                  onPressed: () async {
                    bool show = await _submit();
                    if(show==true){
                      setState(() {
                        _showError = show;
                      });
                    }
                  },
                  highlightColor: Colors.yellow, // Disable highlight color
                  hoverColor: Colors.transparent,
                )
            ),

            RichText(
              text: TextSpan(
                style: defaultStyle,
                children: <TextSpan>[


                  TextSpan(text: 'Dont have an account?'),
                  TextSpan(
                      text: 'Create ',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()..onTap = () {
                        setState(() {

                        });
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}