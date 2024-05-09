import 'package:jinahfoods/app/data/repository/latest_branch_repo%20.dart';

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../../data/api/server.dart';
import '../../../data/model/response/branch_model.dart';
import '../../../data/model/response/category_model.dart';
import '../../../data/model/response/item_model.dart';
import '../../../data/model/response/order_mode.dart';
import '../../../data/repository/branch_repo.dart';
import '../../../data/repository/category_repo.dart';
import '../../../data/repository/featured_item_repo.dart';
import '../../../data/repository/item_repo.dart';
import '../../../data/repository/my_order_repo.dart';
import '../../../data/repository/popular_item_repo.dart';
import '../../../data/repository/popular_branch_repo.dart';
import '../../../data/model/response/banner_modal.dart';

class HomeController extends GetxController {
  static Server server = Server();
  List<OrdersData> activeOrderData = <OrdersData>[];
  List<CategoryData> categoryDataList = <CategoryData>[];
  List<ItemData> itemDataList = <ItemData>[];
  List<ItemData> popularItemDataList = <ItemData>[];
  List<ItemData> featuredItemDataList = <ItemData>[];
  List<BranchData> branchDataList = <BranchData>[];
  List<BranchData> popularBranchDataList = <BranchData>[];
  List<BranchData> latestBranchDataList = <BranchData>[];
  List<BannerModel> banners = [];

  String? selectedBranch;
  int? selectedbranchId;

  bool loader = false;
  int currentIndex = 0;
  int selectedCategoryIndex = 0;
  int vegNonVegActive = 0;
  int vegNonVegActiveList = 0;
  bool fromRestaurantList = true;
  bool menuLoader = false;
  bool featuredLoader = false;
  bool offerLoader = false;
  bool popularLoader = false;
  bool popularBranchLoader = false;
  bool latestBranchLoader = false;
  bool activeOrderLoader = false;
  int selectedBranchIndex = 0;
  bool restaurantItemLoader = false;

  @override
  void onInit() {
    final box = GetStorage();
    getCategoryList();
    getBranchList();
    getPopularItemDataList();
    getFeaturedItemDataList();
    getPopularBranchDataList();
    getLatestBranchDataList();
    fetchBanners();

    getItemDataList();
    if (box.read('isLogedIn') == true && box.read('isLogedIn') != null) {
      getActiveOrderList();
    }
    super.onInit();
  }

  setIndexOfBranch() {
    selectedBranchIndex =
        branchDataList.indexWhere((e) => e.name == selectedBranch);

    selectedbranchId = branchDataList[selectedBranchIndex]
        .id!; //new add for issue in place order page
  }

  setSelectedBranchIndex(int index) {
    selectedBranchIndex = index;
    update();
  }

  setSelectedBranchId(int id) {
    selectedbranchId = id;
    var branch = branchDataList.firstWhere((branch) => branch.id == id);

    // Check if a branch was found and set the selectedBranch to the branch's name
    if (branch != null) {
      selectedBranch = branch.name;
    } else {
      selectedBranch = null; // or set a default value or handle the error
    }
    update();
  }

  int findBranchIndexById(int branchId) {
    return branchDataList.indexWhere((branch) => branch.id == branchId);
  }

  getCategoryList() async {
    menuLoader = true;
    update();

    var categoryData = await CategoryRepo.getCategory();

    if (categoryData != null) {
      categoryDataList = categoryData.data ?? [];
      menuLoader = false;
      update();
    } else {
      menuLoader = false;
      update();
    }
  }

  getBranchList() async {
    var branchData = await BranchRepo.getBranch();
    if (branchData.data != null) {
      branchDataList = branchData.data!;
      setInitialBranch();
      update();
    }
  }

  setInitialBranch() {
    if (selectedBranch == null) {
      selectedBranch = branchDataList[0].name;
      selectedbranchId = branchDataList[0].id!;
    }
  }

  getItemDataList() async {
    var itemData = await ItemRepo.getItem();
    if (itemData != null) {
      itemDataList = itemData.data ?? [];
      update();
    } else {
      update();
    }
  }

  getPopularItemDataList() async {
    popularLoader = true;
    restaurantItemLoader = true;
    update();
    var popularItemData = await PopularItemRepo.getPopularItem();
    if (popularItemData != null) {
      popularItemDataList = popularItemData.data ?? [];
      popularLoader = false;
      restaurantItemLoader = false;
      update();
    } else {
      update();
    }
  }

  getFeaturedItemDataList() async {
    featuredLoader = true;
    restaurantItemLoader = true;
    update();
    var featuredItemData = await FeaturedItemRepo.getFeaturedItem();
    if (featuredItemData != null) {
      featuredItemDataList = featuredItemData.data ?? [];
      print('Length is: ' + featuredItemDataList.length.toString());
      update();
      featuredLoader = false;
      restaurantItemLoader = false;
      update();
    } else {
      update();
    }
  }

  getLatestBranchDataList() async {
    latestBranchLoader = true;
    restaurantItemLoader = true;
    update();
    var latestBranchData = await LatestBranchRepo.getPopularBranches();
    if (latestBranchData != null) {
      latestBranchDataList = latestBranchData.data ?? [];
      update();
      latestBranchLoader = false;
      restaurantItemLoader = false;
      update();
    } else {
      update();
      restaurantItemLoader = false;
    }
  }

  getPopularBranchDataList() async {
    popularBranchLoader = true;
    restaurantItemLoader = false;
    update();
    var popularBranchData = await PopularBranchRepo.getPopularBranches();
    if (popularBranchData != null) {
      popularBranchDataList = popularBranchData.data ?? [];
      update();
      popularBranchLoader = false;
      restaurantItemLoader = false;
      update();
    } else {
      restaurantItemLoader = false;
      update();
    }
  }

  getActiveOrderList() async {
    var activeOrder = await MyOrderRepo.getActiveOrder();
    if (activeOrder != null) {
      activeOrderData = activeOrder.data!;
      update();
    } else {}
  }

  fetchBanners() async {
    String url = 'https://admin.jinahonestop.com/api/frontend/slider';

    await server
        .getRequestWithoutToken(endPoint: url.toString())
        .then((response) {
      if (response != null && response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        banners = jsonData['data']
            .map<BannerModel>((data) => BannerModel.fromJson(data))
            .toList();
        update();
      } else {}
    });
  }
}
