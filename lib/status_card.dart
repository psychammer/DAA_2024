import 'status.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';


class StatusCard extends StatelessWidget {
  final Status status;

  StatusCard({required this.status});

  void _showCustomDialog(BuildContext context, Status status) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Disable dismissing the modal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: CustomDialogContent(status: status),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Card(
          color: Colors.white,
          elevation: 19.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.0), // Customize corner radius
          ),
          child: InkWell(onTap: (){_showCustomDialog(context, status);},
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/truck.png', width: 120,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("Driver's Name:", style: TextStyle(color: Colors.blue[900], fontSize: 12)),
                                Text(status.driver, style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                                Text("Number of Pallet/s:", style: TextStyle(color: Colors.blue[900], fontSize: 12)),
                                Text("${status.pallet_num} pallets", style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                                Text("Profit:", style: TextStyle(color: Colors.blue[900], fontSize: 12)),
                                Text("${status.profit} php", style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                                Text("Date of delivery:", style: TextStyle(color: Colors.blue[900], fontSize: 12)),
                                Text(status.delivery_date, style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold))],
                  ),
              SizedBox(
                height: 150, // Set a finite height (adjust as needed)
                child: Column(
                  children: [
                    Text(status.percent, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 20)),
                    Spacer(), // Takes up remaining space
                    Image.asset('assets/in_progress.png', width: 80.0, fit: BoxFit.contain),

                  ],
                ),
              ),
                ],
              ),
            ),
          )
      ),
    );
  }
}


class CustomDialogContent extends StatelessWidget {

  final Status status;
  CustomDialogContent({required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(); // Close the modal
            },
          ),
        ),
        Image.asset('assets/truck.png', height: 150, width: 200,),
        SizedBox(height: 30,),
        Align(
            alignment: Alignment.center,
            child: Text("Driver Name:", style: TextStyle(fontFamily: 'Inter-Black', fontSize: 18))
        ),
        Align(
            alignment: Alignment.center,
            child: Text("${status.driver}", style: TextStyle(fontFamily: 'Inter-Black', fontSize: 18))
        ),
        SizedBox(height: 10),
        Align(
            alignment: Alignment.center,
            child: Text("Delivery Date:", style: TextStyle(fontFamily: 'Inter-Black', color: Colors.orange, fontSize: 18))
        ),
        Align(
            alignment: Alignment.center,
            child: Text("${status.delivery_date}", style: TextStyle(fontFamily: 'Inter-Black', color: Colors.orange, fontSize: 18))
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            child: IconButton(
              icon: Image.asset('assets/delivered.png'),
              onPressed: () async {Response response = await get(Uri.parse('http://192.168.0.15/delivered?truck_id=${status.name}'));Navigator.pushReplacementNamed(context, '/history');},
              highlightColor: Colors.yellow,
              hoverColor: Colors.transparent,
            )
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            child: IconButton(
              icon: Image.asset('assets/cancelled.png'),
              onPressed: () async {Response response = await get(Uri.parse('http://192.168.0.15/cancelled?truck_id=${status.name}'));; Navigator.pushReplacementNamed(context, '/history');},
              highlightColor: Colors.yellow,
              hoverColor: Colors.transparent,
            )
        ),
      ],
    );
  }
}
