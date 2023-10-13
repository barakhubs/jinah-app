import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';

class BranchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(
      () => CartController(),
    );
  }
}
