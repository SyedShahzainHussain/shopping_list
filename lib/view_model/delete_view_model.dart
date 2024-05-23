import 'package:flutter/material.dart';

import '../model/grocery_item.dart';
import '../repository/delete_grocery_item.dart';

class DeleteViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool get loading => _isLoading;
  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  final deleteGroceryRepository = DeleteGroceryRepository();

  Future<void> deleteGrocery(
    GroceryItem item,
  ) async {
    setLoading(true);
    deleteGroceryRepository.deleteGroceryRepository(item).then((value) {
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
    });
  }
}
