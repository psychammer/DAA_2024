import 'package:flutter/material.dart';


class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              title: Text('TRUCK HISTORY', style: TextStyle(color: Colors.orange)),
              centerTitle: true,
            ),
          ),
          floatingActionButton: Stack(
            children: [
              Container(
                height: 100,
                width: 400,
                child: Image.asset(
                  "assets/history_navigation_bar.png",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  height: 60,
                  right: 150,
                  bottom: 23,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Set the button color to transparent
                        shadowColor: Colors.transparent, // Hide the shadow
                      ),
                      onPressed: () {Navigator.pop(context);},
                      child: Text("")
                  )),
              Positioned(
                  height: 60,
                  left: 50,
                  bottom: 23,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Set the button color to transparent
                      shadowColor: Colors.transparent, // Hide the shadow
                    ),
                    onPressed: () {Navigator.pushReplacementNamed(context, '/item');},
                    child: Text(""),
                  ))
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        )
    );
  }
}
