import 'package:flutter/material.dart';

import 'package:grocerieslistapp/data/dummy_items.dart';
import 'package:grocerieslistapp/models/grocery_item.dart';
import 'package:grocerieslistapp/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _newgroceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.push<GroceryItem>(
        context, MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) {
      return;
    }
    setState(() {
      _newgroceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _newgroceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
        child: Text("Empty Groceries List please try to add the groceries!"));

    if (_newgroceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _newgroceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_newgroceryItems[index]);
          },
          key: ValueKey(_newgroceryItems[index].id),
          child: ListTile(
            title: Text(_newgroceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _newgroceryItems[index].category.color,
            ),
            trailing: Text(
              _newgroceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
