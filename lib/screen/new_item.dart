import 'dart:convert';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/model/category.dart';
import 'package:shopping_list/model/grocery_item.dart';
import 'package:shopping_list/view_model/new_item_view_model.dart';
import 'package:shopping_list/view_model/post_view_model.dart';

import '../data/categories.dart';
import '../view_model/get_view_model.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() => NewItemState();
}

class NewItemState extends State<NewItem> {
  final _form = GlobalKey<FormState>();
  String _enteredName = '';
  int _enteredQuantity = 1;
  Category _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      FocusScope.of(context).requestFocus(FocusNode());
      final grocery = GroceryItem(
          id: DateTime.now().toIso8601String(),
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory);
      if (kDebugMode) {
        print(_selectedCategory.title);
      }
      Provider.of<NewItemViewModel>(context, listen: false)
          .addCategory(grocery);
      Provider.of<PostViewModel>(context, listen: false)
          .postGrocery(jsonEncode(
        {
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory.title,
        },
      ))
          .then((value) {
        Provider.of<GetViewModel>(context, listen: false).getGroceryList();
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Consumer<PostViewModel>(
        builder: (context, data, _) => ModalProgressHUD(
          inAsyncCall: data.loading,
          progressIndicator: const CircularProgressIndicator.adaptive(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length == 1 ||
                          value.trim().length > 50) {
                        return "Must be between 1 and 50 characters";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredName = value!;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: _enteredQuantity.toString(),
                          decoration: const InputDecoration(
                            label: Text('Quantity'),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null ||
                                int.tryParse(value)! <= 0) {
                              return 'Must be a valid, positive number.';
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
                          child: DropdownButtonFormField<Category?>(
                              value: _selectedCategory,
                              items: [
                                for (final category in categories.entries)
                                  DropdownMenuItem(
                                      value: category.value,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 16,
                                            height: 16,
                                            color: category.value.color,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(category.value.title),
                                        ],
                                      ))
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                              }))
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _form.currentState!.reset();
                        },
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        onPressed: _saveItem,
                        child: const Text('Add Item'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
