import 'package:flutter/foundation.dart';
import 'package:shopping_list/repository/post_grocery_item.dart';

class PostViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool get loading => _isLoading;
  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  final postGroceryRepository = PostGroceryRepository();

  Future<void> postGrocery(dynamic body) async {
    setLoading(true);
    await postGroceryRepository.postGrocery(body).then((value) {
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
