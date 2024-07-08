
import 'package:flutter/material.dart';
import 'package:apps/pallet.dart';
import 'package:apps/product.dart';


class BoxStatusCard extends StatefulWidget {
  final Pallet pallet;

  BoxStatusCard({required this.pallet});

  @override
  State<BoxStatusCard> createState() => _BoxStatusCardState();
}

class _BoxStatusCardState extends State<BoxStatusCard> {
  void _showCustomDialog(BuildContext context, List<Product> products, Pallet pallet) {
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
              child: CustomDialogContent(products: products, pallet: widget.pallet),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        shadowColor: Colors.blue,
        color: Colors.white,
        elevation: 19.0 ,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: InkWell(onTap: (){_showCustomDialog(context, widget.pallet.products, widget.pallet);},
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset('assets/box.png', height: 50, width: 60,)
                    ),

                    Align(
                        alignment: Alignment.center,
                        child: Text("${widget.pallet.name}", style: TextStyle(fontFamily: 'Inter-Black', ))
                    ),
                  ]
              )
          ),
        ),
      ),
    );

  }
}

class CustomDialogContent extends StatelessWidget {
  List<Widget> productBuilder(List<Product> products){
    List<Widget> productRow = [];
    for(int i =0; i<products.length; i+=1){
      productRow.add(Padding(
          padding: EdgeInsets.all(5),
          child: Card(
              shadowColor: Colors.blue,
              color: Colors.white,
              elevation: 5.0 ,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/${products[i].name}.png', height: 100, width: 100,),
                        Align(
                            alignment: Alignment.center,
                            child: Text("${products[i].name}", style: TextStyle(fontFamily: 'Inter-Black', ))
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Weight: ${products[i].weight}", style: TextStyle(fontFamily: 'Inter-Black', color: Colors.orange, fontSize: 12)),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Profit: ${products[i].profit}", style: TextStyle(fontFamily: 'Inter-Black', color: Colors.orange, fontSize: 12)),
                        )
                      ]
                  )
              )
          )
      ));
    }
    return productRow;
  }

  final List<Product> products;
  final Pallet pallet;
  CustomDialogContent({required this.products, required this.pallet});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
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
              Image.asset('assets/box.png', height: 150, width: 200,),
              Card(
                  shadowColor: Colors.blue,
                  color: Colors.white,
                  elevation: 5.0 ,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(12, 1, 12, 1),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Text("${pallet.name}", style: TextStyle(fontFamily: 'Inter-Black', fontSize: 24))
                            ),
                            SizedBox(height: 30,),
                            Align(
                                alignment: Alignment.center,
                                child: Text("Total Weight: ${pallet.weight}", style: TextStyle(fontFamily: 'Inter-Black', fontSize: 14))
                            ),
                            SizedBox(height: 10),
                            Align(
                                alignment: Alignment.center,
                                child: Text("Total Profit: ${pallet.profit}", style: TextStyle(fontFamily: 'Inter-Black', color: Colors.orange, fontSize: 14))
                            )
                          ]
                      )
                  )
              ),
              ...productBuilder(products).map((product) { // include all elements of a list (or another iterable) within the list
                return product;
              }).toList(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}


