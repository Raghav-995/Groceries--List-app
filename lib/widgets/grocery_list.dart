import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocerieslistapp/data/categories.dart';
import 'package:http/http.dart' as http;
import 'package:grocerieslistapp/models/grocery_item.dart';
import 'package:grocerieslistapp/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _newgroceryItems = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    final url = Uri.https('flutter-http-ece83-default-rtdb.firebaseio.com',
        'Groceries-Item.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((catItems) =>
              catItems.value.title == item.value['selectedCategory'])
          .value;
      loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    setState(() {
      _newgroceryItems = loadedItems;

      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _newgroceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _newgroceryItems.indexOf(item);
    setState(() {
      _newgroceryItems.remove(item);
    });

    final url = Uri.https('flutter-http-ece83-default-rtdb.firebaseio.com',
        'Groceries-Item/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _newgroceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
        child: Text("Empty Groceries List please try to add the groceries!"));

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

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
