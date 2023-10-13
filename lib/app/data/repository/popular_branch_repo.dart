// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../util/api-list.dart';
import '../api/server.dart';
import '../model/response/branch_model.dart';

class PopularBranchRepo {
  static Server server = Server();
  static BranchModel popularBranches = BranchModel();

  // ignore: body_might_complete_normally_nullable
  static Future<BranchModel?> getPopularBranches() async {
    try {
      await server
          .getRequestWithoutToken(
        endPoint: APIList.popularBranches!,
      )
          .then((response) {
        if (response != null && response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          popularBranches = BranchModel.fromJson(jsonResponse);
          return popularBranches;
        }
      });
      return popularBranches;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
