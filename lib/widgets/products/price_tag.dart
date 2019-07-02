import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String price;

  PriceTag(this.price);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10.0)),
      child: Text(
        '\₹$price',
        // ' ₹ ' + products[index]['price'].toString(),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
