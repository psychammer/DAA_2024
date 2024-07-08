import 'package:flutter/material.dart';
import 'package:apps/delivery_status.dart';
import 'package:apps/delivery_status_card.dart';
import 'package:http/http.dart';
import 'dart:convert';


class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<DeliveryStatus> delivery_status_list = [];


  Future<List<DeliveryStatus>> getDeliveryStatuses() async{
    List<DeliveryStatus> delivery_status_list = [];
    Response response = await get(Uri.parse('http://192.168.0.15/delivery_status_list'));
    Map data = jsonDecode(response.body);

    data['driver'].asMap().forEach((index, truck_name){
      delivery_status_list.add(DeliveryStatus(driver: 'Roljohn Torres', pallet_num: data['number_of_boxes'][index].toString(),
          profit: data['profit'][index].toString(),
          delivery_date: data['date_of_delivery'][index].toString(),
          percent: '${data['load_percentage'][index]}%',
          name: data['truck_id'][index].toString(),
          status: data['status'][index].toString()));
    });


    return delivery_status_list;
  }

  void setDeliveryStatusList() async{
    delivery_status_list = await getDeliveryStatuses();
    setState(() {

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDeliveryStatusList();
  }

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

          body: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [...delivery_status_list.map((delivery_status){
                  setState(() {});
                  return DeliveryStatusCard(
                    deliveryStatus: delivery_status,
                  )
                  ;}).toList(),
                  SizedBox(height: 150)
                ],
              ),
            )
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
                      onPressed: () {setState(() {

                      });
                        Navigator.pop(context);},
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
