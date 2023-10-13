// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../util/api-list.dart';
import '../api/server.dart';
import '../model/response/branch_model.dart';

class RestaurantRepo {
  static Server server = Server();
  static BranchModel restaurantsList = BranchModel();

  // ignore: body_might_complete_normally_nullable
  static Future<BranchModel?> getRestaurants() async {
    try {
      await server
          .getRequestWithoutToken(
        endPoint: APIList.restaurantList!,
      )
          .then((response) {
        if (response != null && response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          restaurantsList = BranchModel.fromJson(jsonResponse);
          return restaurantsList;
        }
      });
      return restaurantsList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
