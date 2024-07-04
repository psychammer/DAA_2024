import 'status.dart';
import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final Status status;

  final void Function() delete;

  StatusCard({required this.status, required this.delete});

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
          )
      ),
    );
  }
}
