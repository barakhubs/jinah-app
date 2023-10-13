// To parse this JSON data, do
//
//     final categoryWiseItemModel = restaurantItemModelFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

import 'item_model.dart';

RestaurantItemModel restaurantItemModelFromJson(String str) =>
    RestaurantItemModel.fromJson(json.decode(str));

String restaurantWiseItemModelToJson(RestaurantItemModel data) =>
    json.encode(data.toJson());

class RestaurantItemModel {
  RestaurantItemModel({
    this.data,
  });

  RestaurantItemData? data;

  factory RestaurantItemModel.fromJson(Map<String, dynamic> json) =>
      RestaurantItemModel(
        data: json["data"] == null
            ? null
            : RestaurantItemData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class RestaurantItemData {
  RestaurantItemData({
    this.id,
    this.name,
    this.thumb,
    this.cover,
    this.items,
  });

  int? id;
  String? name;
  String? cover;
  String? thumb;
  List<ItemData>? items;

  factory RestaurantItemData.fromJson(Map<String, dynamic> json) =>
      RestaurantItemData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        cover: json["cover"] == null ? null : json["cover"],
        thumb: json["thumb"] == null ? null : json["thumb"],
        items: json["items"] == null
            ? null
            : List<ItemData>.from(
                json["items"].map((x) => ItemData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "cover": cover == null ? null : cover,
        "thumb": thumb == null ? null : thumb,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}
