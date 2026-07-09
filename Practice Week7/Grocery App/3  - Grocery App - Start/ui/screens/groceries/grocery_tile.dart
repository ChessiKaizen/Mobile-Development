import 'package:flutter/material.dart';
import '../../../models/grocery.dart';

// ---------------------------------------------
// Create a new stateless widget : GroceryTile
// ---------------------------------------------

// The widget shall take as required parameter a Grocery  

// 	Use a ListTile widget to layout the elements

// https://api.flutter.dev/flutter/material/ListTile-class.html

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.item});

  final GroceryItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: item.category.color,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(item.name),
      subtitle: Text(item.category.label),
      trailing: Text('${item.quantity}x'),
    );
  }
}