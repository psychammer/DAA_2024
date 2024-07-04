import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:typed_data';
import 'package:apps/status.dart';
import 'package:apps/status_card.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Uint8List imageData = Uint8List(0);

  List<Status> statuses= [
    Status(driver:'Roljohn P. Torres', pallet_num: '9', profit: '452', delivery_date: '05/11/2024', percent: '80%'),
    Status(driver:'Roljohn P. Torres', pallet_num: '9', profit: '452', delivery_date: '05/11/2024', percent: '80%')
  ];


  Future<void> fetchImage() async {
    Response response = await  get(Uri.parse('http://192.168.0.15/weekly_profit'));
    if (response.statusCode == 200) {
      setState(() {
        imageData = response.bodyBytes;
      });
    } else {
      print('Failed to load image: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImage();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              // title: Text("Roljohn",
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //     )
              // ),
                flexibleSpace: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/IKEA_logo.png'),
                            fit: BoxFit.fill
                        )
                    )
                ),
                centerTitle: true
            )
        ),

        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[Card(
                  elevation: 6,
                  color: Colors.white,
                  margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if(imageData==Uint8List(0))
                          Container()
                        else
            
                          Image.memory(imageData)
                        ,
                        Text(
                          "Database monitoring daily profit fluctuations for real-time insights",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter-Black'
                          ),
                        ),
                      ],
                    ),
                  )
              ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    "List",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter-Black'
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20), child: IconButton(
                      icon: Image.asset('assets/pallet.png'),
                      onPressed: () async {
                        Navigator.pushNamed(context, '/item');
                      },
                      highlightColor: Colors.yellow,
                      hoverColor: Colors.transparent,
                    )),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20), child: IconButton(
                      icon: Image.asset('assets/truck.png'),
                      onPressed: () async {
                        Navigator.pushNamed(context, '/history');
                      },
                      highlightColor: Colors.yellow,
                      hoverColor: Colors.transparent,
                    ))
                  ],
                ),

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                    child: IconButton(
                      icon: Image.asset('assets/ship.png'),
                      onPressed: (){Navigator.pushNamed(context, '/ship');},
                      highlightColor: Colors.yellow,
                      hoverColor: Colors.transparent,
                    )
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(
                    "Recent Status",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter-Black'
                    ),
                  ),
                ),

                Column(
                  children: statuses.map((status)=> StatusCard(
                      status: status,
                      delete: (){
                        setState(() {
                          statuses.remove(status);
                        });
                      })).toList(),
                ),

                SizedBox(
                  height: 100,
                )

              ],
            ),
          ),
        ),

        floatingActionButton: Stack(
          children: [
            Container(
              height: 100,
              width: 400,
              child: Image.asset(
                "assets/home_navigation_bar.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                height: 60,
                right: 50,
                bottom: 23,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Set the button color to transparent
                    shadowColor: Colors.transparent, // Hide the shadow
                  ),
                  onPressed: () {Navigator.pushNamed(context, '/history');},
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
                  onPressed: () {Navigator.pushNamed(context, '/item');},
                  child: Text(""),
                ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
