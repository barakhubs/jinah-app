import 'package:get/get.dart';
import 'package:jinahfoods/app/data/api/server.dart';
import 'package:jinahfoods/app/modules/home/controllers/home_controller.dart';
import 'package:jinahfoods/util/api-list.dart';
import '../../../data/model/response/time_slot_model.dart';
import '../../../data/repository/time_slot_repo.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckoutController extends GetxController {
  bool couponApplied = false;
  int selectDateSlot = 0;
  int selectTimeSlot = 0;

  List<TimeSlotData> todayDataList = <TimeSlotData>[];
  List<TimeSlotData> tomorrowDataList = <TimeSlotData>[];

  HomeController homeController = Get.find<HomeController>();

  Server server = Server();

  final TimeSlotRepo timeSlotRepo =
      TimeSlotRepo(); // Create an instance of TimeSlotRepo

  @override
  void onInit() {
    super.onInit();
    fetchTimeSlots();
  }

  void fetchTimeSlots() async {
    try {
      await Future.wait([getTodayTime(), getTomorrowTime()]);
    } catch (e) {
      print('Error fetching time slots: $e');
    }
  }

  Future<void> getTodayTime() async {
    var todayData =
        await timeSlotRepo.getTodayTimeSlot(); // Call method on the instance
    if (todayData != null) {
      todayDataList = todayData.data ?? [];
    }
    update();
  }

  Future<void> getTomorrowTime() async {
    var tomorrowData =
        await timeSlotRepo.getTomorrowTimeSlot(); // Call method on the instance
    if (tomorrowData != null) {
      tomorrowDataList = tomorrowData.data ?? [];
    }
    update();
  }

  void updateDateSlot(int index) {
    selectDateSlot = index;
    update();
  }

  void updateTimeSlot(int index) {
    selectTimeSlot = index;
    update();
  }

  /// Checks if the current time falls within the opening and closing times of the selected time slot.
  /// Assumes `opening_time` and `closing_time` are in "HH:mm" format.
  Future<bool> isCurrentTimeInSelectedSlot() async {
    int? defaultBranch = homeController.selectedbranchId;
    bool isOpen = false; 

    final String url = "${APIList.todayTimeSlot}${defaultBranch.toString()}";
    try {
      final response = await server.getRequest(
        endPoint: "${APIList.todayTimeSlot}${defaultBranch.toString()}",
      );

      if (response != null && response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        isOpen = responseBody['isOpen'];   

        return isOpen;     
      }

      print(response.statusCode);
      return isOpen;
    } catch (e) {
      print('Error fetching time slot: $e');
      return false; // Return false on exception
    }
  }
}
