import 'package:flutter/foundation.dart';
import 'package:shopping_list/data/network/base_api_services.dart';
import 'package:shopping_list/data/network/network_api_services.dart';
import 'package:shopping_list/utils/app_url.dart';

class PostGroceryRepository {
  final BaseApiServices baseApiServices = NetworkApiServices();

  Future<void> postGrocery(dynamic body) async {
    try {
      final resposne =
          await baseApiServices.getPostApiResponse(AppUrl.groceryUrl, body);
      if (kDebugMode) {
        print(resposne);
      }
    } catch (_) {
      rethrow;
    }
  }
}
