import 'package:flutter/material.dart';
import '../../../data/mock_grocery_data.dart';
import '../../../models/grocery.dart';
import 'grocery_form.dart';
import 'grocery_tile.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  final List<GroceryItem> _groceryItems = List.from(allGroceryItems);

  void onCreate() {
    
    // ---------------------------------------------
    // Navigate to the form screen using showModalBottomSheet
    // ---------------------------------------------

    // https://api.flutter.dev/flutter/material/showModalBottomSheet.html

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => GroceryForm(
        onAddItem: (newItem) {
          setState(() {
            _groceryItems.add(newItem);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (_groceryItems.isNotEmpty) {
      // ---------------------------------------------
      //  Loop on groceries with an ListView builder
      //  For each grocery items, create a GroceryTile (grocery_tile.dart)
      // ---------------------------------------------
      // https://api.flutter.dev/flutter/widgets/ListView-class.html

      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (cotext, index) {
          return GroceryTile(item: _groceryItems[index]);
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: onCreate, icon: const Icon(Icons.add)),
        ],
      ),
      body: content,
    );
  }
}
