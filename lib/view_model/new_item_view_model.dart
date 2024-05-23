import 'package:flutter/material.dart';
import 'package:shopping_list/model/grocery_item.dart';

class NewItemViewModel with ChangeNotifier {
  final List<GroceryItem> _category = [];
  List<GroceryItem> get category => [..._category];

  void setCategory(List<GroceryItem> category) {
    _category.addAll(category);
    notifyListeners();
  }

  void addCategory(GroceryItem category) {
    _category.add(category);
    notifyListeners();
  }

  void deleteCategory(GroceryItem groceryItem, BuildContext context) {
    final index = _category.indexOf(groceryItem);
    _category.remove(groceryItem);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: const Text("Item is Delete"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              _category.insert(index, groceryItem);
              notifyListeners();
            }),
      ));
    notifyListeners();
  }
}
