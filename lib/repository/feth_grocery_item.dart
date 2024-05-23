import 'package:shopping_list/utils/app_url.dart';

import '../data/app_exception.dart';
import '../data/network/base_api_services.dart';
import '../data/network/network_api_services.dart';

class FetchGroceryRepository {
  final BaseApiServices baseApiServices = NetworkApiServices();

  Future<Map<String, dynamic>> getGroceryRepository() async {
    try {
      final response =
          await baseApiServices.getGetApiResponse(AppUrl.groceryUrl);

      if (response == null) {
        throw BadRequestException("No Data Found in database");
      }

      return response;
    } catch (error) {
      rethrow;
    }
  }
}
