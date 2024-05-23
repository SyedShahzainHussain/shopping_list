import 'package:flutter/foundation.dart';
import 'package:shopping_list/data/response/api_response.dart';

import '../repository/feth_grocery_item.dart';

class GetViewModel with ChangeNotifier {
  FetchGroceryRepository fetchGroceryRepository = FetchGroceryRepository();

  ApiResponse<Map<String, dynamic>> groceryList = ApiResponse.loading();

  setCategoryList(ApiResponse<Map<String, dynamic>> groceryList) {
    this.groceryList = groceryList;
    notifyListeners();
  }

  Future<void> getGroceryList() async {
await    fetchGroceryRepository.getGroceryRepository().then((value) {
      if (kDebugMode) {
        print(value);
      }
      setCategoryList(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      setCategoryList(ApiResponse.error(error.toString()));
    });
  }
}
