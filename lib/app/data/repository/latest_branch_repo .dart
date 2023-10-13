// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../util/api-list.dart';
import '../api/server.dart';
import '../model/response/branch_model.dart';

class LatestBranchRepo {
  static Server server = Server();
  static BranchModel latestBranches = BranchModel();

  // ignore: body_might_complete_normally_nullable
  static Future<BranchModel?> getPopularBranches() async {
    try {
      await server
          .getRequestWithoutToken(
        endPoint: APIList.latestBranches!,
      )
          .then((response) {
        if (response != null && response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          latestBranches = BranchModel.fromJson(jsonResponse);
          return latestBranches;
        }
      });
      return latestBranches;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
