import 'package:flutter/material.dart';
import 'package:apps/product.dart';
import 'package:apps/pallet.dart';
import 'package:apps/box_status_card.dart';
import 'package:http/http.dart';
import 'dart:convert';



class BoxStatus extends StatefulWidget {
  const BoxStatus({super.key});

  @override
  State<BoxStatus> createState() => _BoxState();
}

class _BoxState extends State<BoxStatus> {
  Map data_args = {};


  List<Widget> boxBuilder(List<Pallet> boxes) {
    List<Row> rows = [];
    for (int i = 0; i < boxes.length; i += 3) {
      List<Widget> boxesRow = [];

      boxesRow.add(BoxStatusCard(pallet: boxes[i]));

      if (i + 1 < boxes.length) {
        boxesRow.add(BoxStatusCard(pallet: boxes[i + 1]));
      }

      if (i + 2 < boxes.length) {
        boxesRow.add(BoxStatusCard(pallet: boxes[i + 2]));
      }

      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: boxesRow,
      ));
    }
    return rows;
  }


  List<Pallet> boxes = [];
  Future<List<Pallet>> getBoxesList() async{
    Response response = await get(Uri.parse('http://192.168.0.15/truck_box_list?Query=${data_args['truck_id']}&Query2=${data_args['status']}'));
    Map data = jsonDecode(response.body);
    List<Pallet> pallets = [];
    List<Product> products = [];

    data['pallet_names'].asMap().forEach((index, palletName){
      data['pallets'][index]['name'].asMap().forEach((index2, productName){
        products.add(
            Product(name: productName,
                profit: data['pallets'][index]['profit'][index2].toDouble(),
                volume: data['pallets'][index]['volume'][index2].toDouble(),
                quantity: data['pallets'][index]['quantity'][index2].toDouble(),
                weight: data['pallets'][index]['weight'][index2].toDouble()));
      });
      pallets.add(
          Pallet(products: products, name: data['pallet_names'][index])
      );
      products = [];
    });

    return pallets;
  }
  void setProductList() async{
    boxes = await getBoxesList();
    setState(() {
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move context-dependent code here
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && data_args.isEmpty) {
      setState(() {
        data_args = args;
      });
      setProductList();
    }
    setProductList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            title: Text('LIST OF PALLETS', style: TextStyle(color: Colors.orange)),
            centerTitle: true,
          ),
        ),

        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/truck.png'),

                SizedBox(height: 10),
                Text("Truck ID: ${data_args['truck_id']}", style: TextStyle(fontFamily: 'Inter-Black')),

                SizedBox(height: 10),
                Text("Total Profit: ${data_args['total_profit']} php", style: TextStyle(fontFamily: 'Inter-Black')),

                SizedBox(height: 10),
                Text("Load Percentage: ${data_args['load_percentage']}", style: TextStyle(fontFamily: 'Inter-Black')),


                ...boxBuilder(boxes).map((box) { // include all elements of a list (or another iterable) within the list
                  return box;
                }).toList(),
                // You can also add another widget at the end if needed.
                SizedBox(height: 150), // Example widget for spacing
              ],
            ),
          ),
        ),

        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 1,
              height: 110,
              width: 330,
              right: 3,
              child: Image.asset(
                "assets/item_navigation_bar.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              height: 70,
              width: 70,
              right: 30,
              bottom: 120,
              child: FloatingActionButton(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  tooltip: 'Increment',
                  onPressed: (){Navigator.pushNamed(context, '/add_item').then((result){setProductList(); setState(() {});}
                  );},
                  child: Icon(Icons.add)
              ),
            ),
            Positioned(
                height: 60,
                right: 43,
                bottom: 28,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Set the button color to transparent
                      shadowColor: Colors.transparent, // Hide the shadow
                    ),
                    onPressed: () {Navigator.pushReplacementNamed(context, '/history');},
                    child: Text("")
                )),
            Positioned(
                height: 60,
                left: 160,
                bottom: 29,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,  // Set the button color to transparent
                    shadowColor: Colors.transparent, // Hide the shadow
                  ),
                  onPressed: () {Navigator.pop(context);},
                  child: Text(""),
                ))
          ],
        ),

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}



