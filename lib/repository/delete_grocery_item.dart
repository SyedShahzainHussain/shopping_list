import 'package:shopping_list/utils/app_url.dart';

import '../data/app_exception.dart';
import '../data/network/base_api_services.dart';
import '../data/network/network_api_services.dart';
import '../model/grocery_item.dart';

class DeleteGroceryRepository {
  final BaseApiServices baseApiServices = NetworkApiServices();

  Future<void> deleteGroceryRepository(GroceryItem item) async {
    try {
      final response = await baseApiServices
          .getDeleteApiResponse("${AppUrl.deleteGroceryUrl}/${item.id}.json");

      if (response == null) {
        throw BadRequestException("No Data Found in database");
      }

      return response;
    } catch (error) {
      rethrow;
    }
  }
}
