import 'package:flutter/material.dart';
import 'package:apps/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool chosen;
  final bool include;
  final void Function() tap;

  ProductCard({required this.product, required this.tap, required this.chosen, required this.include});

  @override
  State<ProductCard> createState() => _ProductCardState();
}



class _ProductCardState extends State<ProductCard> {
  bool goAhead = false;
  Color _shapeColor = Colors.transparent;

  void setColor(){
    _shapeColor = Colors.black;
  }


  String getProductType(String text){ // get the product type in texts
    RegExp regex = RegExp(r'^[a-zA-Z]+');
    regex.firstMatch(text);
    // Use regex and text to extract the letters
    Match? match = regex.firstMatch(text);

    if (match != null) {
      String extractedText = match.group(0)!;
      return extractedText;
    } else {
      String extractedText = 'null';
      return extractedText;
    }
  }

  @override
  Widget build(BuildContext context) {

    if(widget.chosen==true && widget.include==true){
      _shapeColor = Colors.black;
    }
    else if(widget.chosen==true && widget.include==false){
      _shapeColor = Colors.transparent;
    }
    else if(widget.chosen==false && widget.include==true){
      _shapeColor = _shapeColor;
    }
    else if(widget.chosen==false && widget.include==false){
      _shapeColor = _shapeColor;
    }



    void changeShapeColor(){
      setState((){
        _shapeColor = _shapeColor == Colors.transparent? Colors.black : Colors.transparent;
      });
    }


    return Padding(
      padding: EdgeInsets.all(8),
      child: Card(
        shadowColor: Colors.blue,
        color: Colors.white,
        elevation: 19.0 ,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: InkWell(
          onTap: (){
            changeShapeColor();
            widget.tap();
            goAhead=true;
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _shapeColor,
                      border: Border.all(color: Colors.black, width: 2)
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Image.asset('assets/${getProductType(widget.product.name)}.png', height: 50, width: 50,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("${getProductType(widget.product.name).toUpperCase()}", style: TextStyle(fontFamily: 'Inter-Black', ))
                ),

                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("${widget.product.profit} PHP | ${widget.product.weight} kg", style: TextStyle(fontFamily: 'Inter-Black', fontSize: 10))
                ),

                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("| ${widget.product.volume} m³", style: TextStyle(fontFamily: 'Inter-Black', fontSize: 10))
                )


              ]
            )
          )
        )
      )
    );
  }
}
