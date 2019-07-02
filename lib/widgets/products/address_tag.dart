import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {
  final String address;
  AddressTag(this.address);
  @override
  Widget build(BuildContext context) {
    return
        //also add DecoratedBox insteed of Container
        Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(address),
    );
  }
}
