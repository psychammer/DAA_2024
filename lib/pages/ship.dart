import 'package:flutter/material.dart';
import 'package:apps/pallet_ship_card.dart';
import 'package:apps/product.dart';
import 'package:apps/pallet.dart';
import 'package:apps/truck.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:math';


class Ship extends StatefulWidget {
  bool autoChooseClicked = false;

  @override
  State<Ship> createState() => _ShipState();
}

class _ShipState extends State<Ship> {
  int weightCapacity = 1000;

  double totalProfit = 0;
  double totalWeight = 0;
  Truck truck = Truck(boxes: [], name: "Roljohn P. Torres");

  Future<List<Pallet>> getBoxesList() async{
    Response response = await get(Uri.parse('http://192.168.0.15/boxes_list'));
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

  List<Pallet> boxes =[];


  List<Pallet> chooseBoxes(List<Pallet> boxes){
    getBoxesList();
    List<int> prices = [0];
    List<int> weights = [0];

    prices.addAll(boxes.map((box) => box.profit.toInt()));
    weights.addAll(boxes.map((box) => box.weight.toInt()));

    int numberOfItems = prices.length;
    List<int> capacity = [weightCapacity];


    List<List<int>> table = List.generate(
        numberOfItems,
            (_) => List.filled(
            capacity[0] + 1, 0
        )
    );

    for (int i = 0; i < numberOfItems; i++) {
      for (int j = 1; j <= capacity[0]; j++) {
        if (i > 0) {
          int lhs = table[i - 1][j];
          int rhs = (j >= weights[i])
              ? table[i - 1][j - weights[i]] + prices[i]
              : 0;
          table[i][j] = max(lhs, rhs);
        }
      }
    }


    List<int> knapsack = List.filled(numberOfItems, 0);
    int idx = numberOfItems - 1;
    int i = capacity[0];
    while (i >= 0 && idx >= 0) {
      if (table[idx][i] != (idx > 0 ? table[idx - 1][i] : 0)) {
        knapsack[idx] = 1;
        i -= weights[idx];
      }
      idx--;
    }

    knapsack = knapsack.sublist(1);

    List<Pallet> chosenBoxes = [];
    for(int i = 0; i<boxes.length; i++){
      if(knapsack[i] == 1){
        chosenBoxes.add(boxes[i]);
      }
    }

    return chosenBoxes;
  } // knapsack

  List<Pallet>chosenBoxes = [];
  List<String> chosenBoxNames = [];
  List<Widget> boxBuilder(List<Pallet> boxes, bool chosen){

    if(chosen == true){
      chosenBoxes = chooseBoxes(boxes);
      chosenBoxNames = chosenBoxes.map((box) => box.name).toList();
    }

    List<Row> rows = [];
    for(int i =0; i<boxes.length; i+=2){
      bool exists = false;


      if(chosenBoxNames.contains(boxes[i].name)){
        exists=true;
      }
      List<Widget> boxRow = [];
      boxRow.add(PalletShipCard(pallet: boxes[i],
          tap: (){
            setState(() {
              bool productExists = truck.boxes.any((box) => box.name == boxes[i].name);

              if (productExists) {
                truck.boxes.removeWhere((box) => box.name == boxes[i].name);
              } else {
                truck.boxes.add(boxes[i]);
              }

              totalProfit = truck.boxes.fold(0, (total, box) => total + box.profit);
              totalWeight = truck.boxes.fold(0, (total, box) => total + box.weight);
              widget.autoChooseClicked=false;
            });
          }, chosen: chosen, include: exists));

      if(i+1 < boxes.length){
        if(chosenBoxNames.contains(boxes[i+1].name)){
          exists=true;
        }
        else{
          exists=false;
        }


        boxRow.add(PalletShipCard(pallet: boxes[i+1],
            tap: (){
              setState(() {
                bool productExists = truck.boxes.any((box) => box.name == boxes[i+1].name);
                // print(products[i+1].name);

                if (productExists) {
                  truck.boxes.removeWhere((box) => box.name == boxes[i+1].name);
                } else {
                  truck.boxes.add(boxes[i+1]);
                }
                totalProfit = truck.boxes.fold(0, (total, box) => total + box.profit);
                totalWeight = truck.boxes.fold(0, (total, box) => total + box.weight);
                widget.autoChooseClicked=false;
              });
            }, chosen: chosen, include: exists));
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: boxRow));
      }
      else{
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: boxRow));
      }
    }
    return rows;
  }//builder



  void setBoxesList() async{
    boxes = await getBoxesList();
    setState(() {
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setBoxesList();
    // print('hey there');
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              title: Text('SHIP', style: TextStyle(color: Colors.orange)),
              centerTitle: true,
            ),
          ),
          body: Scrollbar(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Padding(padding: EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Image.asset('assets/truck.png'),
                                onPressed: (){},
                                highlightColor: Colors.yellow,
                                hoverColor: Colors.transparent,
                              ),
                            )
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Text(
                            "Total Capacity: ${totalWeight} / ${weightCapacity} Kg",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter-Black'
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Text(
                            "Total Profit: ${totalProfit} php",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter-Black'
                            ),
                          ),
                        ),

                        totalWeight>weightCapacity?Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Text(
                            "Weight overflow please select the appropriate set of products.",
                            style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter-Black'
                            ),
                          ),
                        ): Container(),


                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: IconButton(
                              icon: Image.asset('assets/ship.png'),
                              onPressed: ()async {
                                var url = Uri.parse('http://192.168.0.15/ship');
                                var headers = <String, String>{
                                  'Content-Type': 'application/json', // Adjust content type based on your API requirements
                                };
                                var body = jsonEncode({
                                  'name': truck.boxes.map((box) => box.name).toList(),
                                });

                                try {
                                  var response = await post(url, headers: headers, body: body);

                                  if (response.statusCode == 200) {
                                    print('POST request successful');
                                    print('Response body: ${response.body}');
                                  } else {
                                    print('POST request failed with status: ${response.statusCode}');
                                    print('Response body: ${response.body}');
                                  }
                                } catch (e) {
                                  print('POST request failed: $e');
                                }


                                Navigator.pop(context);
                              },
                              highlightColor: Colors.yellow, // Disable highlight color
                              hoverColor: Colors.transparent,
                            )
                        ),

                        Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Image.asset('assets/auto_choose_button.png'),
                              onPressed: (){
                                widget.autoChooseClicked?widget.autoChooseClicked=false:widget.autoChooseClicked=true;
                                setState(() {
                                  if(widget.autoChooseClicked==true){
                                    truck = Truck(boxes: [], name:"Roljohn P. Torres");
                                    List<Pallet> autoBox = chooseBoxes(boxes);
                                    truck.boxes = autoBox;

                                    totalProfit = truck.boxes.fold(0, (total, box) => total + box.profit);
                                    totalWeight = truck.boxes.fold(0, (total, box) => total + box.weight);
                                  }
                                });
                              },
                              highlightColor: Colors.blue, // Disable highlight color
                              hoverColor: Colors.transparent,
                            )
                        ),


                        Column(
                          children:boxBuilder(boxes, widget.autoChooseClicked).map((box) => box).toList(),
                        )

                      ]
                  )
              )
          )

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
