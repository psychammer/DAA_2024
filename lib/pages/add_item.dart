import 'package:flutter/material.dart';
import 'package:apps/product_card.dart';
import 'package:apps/product.dart';
import 'package:apps/pallet.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:math';


class AddItem extends StatefulWidget {
  bool autoChooseClicked = false;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  int weightCapacity = 500;
  int volumeCapacity = 200;

  double totalProfit = 0;
  double totalWeight = 0;
  double totalVolume = 0;
  Pallet pallet = Pallet(products: [], name:'');


  Future<List<Product>> getProductList() async{
    Response response = await get(Uri.parse('http://192.168.0.15/product_list'));
    Map data = jsonDecode(response.body);
    List<Product> products = [];

    data['name'].asMap().forEach((index, productName){
      products.add(
        Product(name: productName,
            profit: data['profit'][index].toDouble(),
            volume: data['volume'][index].toDouble(),
            quantity: data['quantity'][index].toDouble(),
            weight: data['weight'][index].toDouble()));
    });

    return products;
  }


  List<Product> products = [Product(name: 'couch', profit: 252, volume: 100, quantity: 2, weight: 100),
                            Product(name: 'sofa', profit: 501, volume: 160, quantity: 5, weight: 100),
                            Product(name: 'table', profit: 240, volume: 120, quantity: 5, weight: 50),
                            Product(name: 'lamp', profit: 50, volume: 20, quantity: 2, weight: 10)];



  List<Product> chosenProducts(List<Product> products){
    getProductList();
    List<int> prices = [0];
    List<int> weights = [0];
    List<int> volumes = [0];

    prices.addAll(products.map((product) => product.profit.toInt()));
    weights.addAll(products.map((product) => product.weight.toInt()));
    volumes.addAll(products.map((product) => product.volume.toInt()));

    int numberOfItems = prices.length;
    List<int> capacity = [weightCapacity, volumeCapacity];


    List<List<List<int>>> table = List.generate(
      numberOfItems,
        (_) => List.generate(
          capacity[0] + 1,
            (_) => List.generate(capacity[1] + 1, (_) => 0)
        )
    );

    for (int i = 0; i < numberOfItems; i++) {
      if (i > 0) {
        for (int j = 0; j <= capacity[0]; j++) {
          if (j > 0) {
            for (int k = 0; k <= capacity[1]; k++) {
              if (k > 0) {
                int lhs =
                (i - 1 >= 0 && j >= 0 && k >= 0) ? table[i - 1][j][k] : 0;
                int rhs =
                (i - 1 >= 0 && j - weights[i] >= 0 && k - volumes[i] >= 0)
                    ? table[i - 1][j - weights[i]][k - volumes[i]] + prices[i]
                    : 0;
                table[i][j][k] = max(lhs, rhs);
              }
            }
          }
        }
      }
    }

    List<int> knapsack = List.filled(numberOfItems, 0);
    int idx = numberOfItems - 1;
    int i = capacity[0];
    int j = capacity[1];

    while (i >= 0 && idx >= 0) {
      while (j >= 0 && idx >= 0) {
        if (table[idx][i][j] != (idx > 0 ? table[idx - 1][i][j] : 0)) {
          knapsack[idx] = 1;
          i -= weights[idx];
          j -= volumes[idx];
        }
        idx--;
      }
    }

    knapsack = knapsack.sublist(1);

    List<Product> chosenProds = [];
    for(int i = 0; i<products.length; i++){
      if(knapsack[i] == 1){
        chosenProds.add(products[i]);
      }
    }

    return chosenProds;
  }

  List<Product>chosenProds = [];
  List<String> chosenProdNames = [];
  List<Widget> productBuilder(List<Product> products, bool chosen){

    if(chosen == true){
      chosenProds = chosenProducts(products);
      chosenProdNames = chosenProds.map((prod) => prod.name).toList();
    }

    List<Row> rows = [];
    for(int i =0; i<products.length; i+=2){
      bool exists = false;


      if(chosenProdNames.contains(products[i].name)){
        exists=true;
      }
      List<Widget> productRow = [];
      productRow.add(ProductCard(product: products[i],
          tap: (){
            setState(() {
              bool productExists = pallet.products.any((product) => product.name == products[i].name);

              if (productExists) {
                pallet.products.removeWhere((product) => product.name == products[i].name);
              } else {
                pallet.products.add(products[i]);
              }

              totalProfit = pallet.products.fold(0, (total, product) => total + product.profit);
              totalWeight = pallet.products.fold(0, (total, product) => total + product.weight);
              totalVolume = pallet.products.fold(0, (total, product) => total + product.volume);
              widget.autoChooseClicked=false;
            });
          }, chosen: chosen, include: exists));

      if(i+1 < products.length){
        if(chosenProdNames.contains(products[i+1].name)){
          exists=true;
        }
        else{
          exists=false;
        }


        productRow.add(ProductCard(product: products[i+1],
            tap: (){
              setState(() {
                bool productExists = pallet.products.any((product) => product.name == products[i+1].name);
                // print(products[i+1].name);

                if (productExists) {
                  pallet.products.removeWhere((product) => product.name == products[i+1].name);
                } else {
                  pallet.products.add(products[i+1]);
                }
                totalProfit = pallet.products.fold(0, (total, product) => total + product.profit);
                totalWeight = pallet.products.fold(0, (total, product) => total + product.weight);
                totalVolume = pallet.products.fold(0, (total, product) => total + product.volume);
                widget.autoChooseClicked=false;
              });
            }, chosen: chosen, include: exists));
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: productRow));
      }
      else{
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: productRow));
      }
    }
    return rows;
  }//builder



  void setProductList() async{
    products = await getProductList();
    setState(() {
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setProductList();
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
            title: Text('ADD ITEMS', style: TextStyle(color: Colors.orange)),
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
                      icon: Image.asset('assets/pallet.png'),
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
                    "Total Volume: ${totalVolume} m³ / ${volumeCapacity}  m³",
                    style: TextStyle(
                        color: totalVolume>400?Colors.red: Colors.black,
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

                totalVolume>volumeCapacity?Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(
                    "Volume overflow please select the appropriate set of products.",
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
                      icon: Image.asset('assets/save_button.png'),
                      onPressed: ()async {
                        var url = Uri.parse('http://192.168.0.15/update_list');
                        var headers = <String, String>{
                          'Content-Type': 'application/json', // Adjust content type based on your API requirements
                        };
                        var body = jsonEncode({
                          'name': pallet.products.map((prod) => prod.name).toList(),
                          'profit':pallet.products.map((prod) => prod.profit).toList(),
                          'volume':pallet.products.map((prod) => prod.volume).toList(),
                          'quantity':pallet.products.map((prod) => prod.quantity).toList(),
                          'weight':pallet.products.map((prod) => prod.weight).toList()
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

                        setState(() {
                        });

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
                            pallet = Pallet(products: [], name:'');
                            List<Product> autoProduct = chosenProducts(products);
                            pallet.products = autoProduct;

                            totalProfit = pallet.products.fold(0, (total, product) => total + product.profit);
                            totalWeight = pallet.products.fold(0, (total, product) => total + product.weight);
                            totalVolume = pallet.products.fold(0, (total, product) => total + product.volume);
                          }
                        });
                      },
                      highlightColor: Colors.blue, // Disable highlight color
                      hoverColor: Colors.transparent,
                    )
                ),


                Column(
                  children:productBuilder(products, widget.autoChooseClicked).map((product) => product).toList(),
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
