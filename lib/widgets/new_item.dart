import 'package:flutter/material.dart';
import 'package:grocerieslistapp/data/categories.dart';
import 'package:grocerieslistapp/models/category.dart';
import 'package:grocerieslistapp/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.fruit]!;
  void _savedItem() {
    if (_formKey.currentState!.validate()) _formKey.currentState!.save();
    Navigator.of(context).pop(GroceryItem(
        id: DateTime.now().toString(),
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _selectedCategory));
    print(_enteredName);
    print(_enteredQuantity);
    print(_selectedCategory);
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a new Item'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(label: Text('Name')),
                      validator: (value) {
                        if (value == null ||
                            value.trim().length <= 1 ||
                            value.isEmpty ||
                            value.trim().length >= 50) {
                          return 'Enter the valid String between 1 to 50 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredName = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Quantity'),
                          ),
                          initialValue: _enteredQuantity.toString(),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                int.tryParse(value) == null ||
                                value.isEmpty ||
                                int.tryParse(value)! <= 0) {
                              return 'Must be a valid, positive integer.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredQuantity = int.parse(value!);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                          child: DropdownButtonFormField(
                              value: _selectedCategory,
                              items: [
                                for (final category in categories.entries)
                                  DropdownMenuItem(
                                      value: category.value,
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 16,
                                              width: 16,
                                              color: category.value.color),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(category.value.title),
                                        ],
                                      )),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                              })),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        onPressed: _savedItem,
                        child: const Text('Add Item'),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }
}
