import 'dart:convert';
import 'package:get/get.dart'; // Ensure you have this import for GetX
import 'package:jinahfoods/app/modules/home/controllers/home_controller.dart';

import '../../../util/api-list.dart';
import '../api/server.dart';
import '../model/response/time_slot_model.dart';

class TimeSlotRepo {
  Server server = Server();
  HomeController homeController = Get.find<HomeController>();

  TimeSlotRepo() {
    // Perform any necessary initialization here
  }

  Future<TimeSlotModel?> getTodayTimeSlot() async {
    int? defaultBranch = 4;
    try {
      final response = await server.getRequest(
        endPoint: "${APIList.todayTimeSlot}${defaultBranch.toString()}",
      );
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return TimeSlotModel.fromJson(jsonResponse);
      }
    } catch (e) {
      print("Error fetching today's time slot: $e");
    }
    return null;
  }

  Future<TimeSlotModel?> getTomorrowTimeSlot() async {
    try {
      final response = await server.getRequestWithoutToken(
        endPoint: "${APIList.tomorrowTimeSlot}",
      );
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return TimeSlotModel.fromJson(jsonResponse);
      }
    } catch (e) {
      print("Error fetching tomorrow's time slot: $e");
    }
    return null;
  }
}
