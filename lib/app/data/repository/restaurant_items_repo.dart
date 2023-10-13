import 'dart:convert';
import '../../../util/api-list.dart';
import '../api/server.dart';
import '../model/response/restaurant_with_items_modal.dart';

class RestaurantItemsRepo {
  static Server server = Server();
  static RestaurantItemModel restaurantItemModel = RestaurantItemModel();

  static Future<RestaurantItemModel?> getRestaurantItem(int id) async {
    try {
      await server
          .getRequestWithoutToken(
        endPoint: APIList.restaurantItems! + id.toString(),
      )
          .then((response) {
        if (response != null && response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          restaurantItemModel = RestaurantItemModel.fromJson(jsonResponse);

          return restaurantItemModel;
        }
      });
      return restaurantItemModel;
    } catch (e) {
      return restaurantItemModel;
    }
  }
}
