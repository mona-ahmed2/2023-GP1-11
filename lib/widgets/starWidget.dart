import 'package:flutter/material.dart'; 

class starWidget extends StatelessWidget {
  final bool selected ; 

  const starWidget(
      {Key? key,
      required this.selected, })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return   Icon(
                Icons.star,
                color: selected ? Colors.orange : Colors.grey,
                size: 35,
              ); 
  }
}
