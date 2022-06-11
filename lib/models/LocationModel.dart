import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ict4farmers/utils/Utils.dart';

part 'LocationModel.g.dart';

@HiveType(typeId: 52)
class LocationModel extends HiveObject {
  static Future<List<LocationModel>> get_all() async {
    List<LocationModel> items = [];

    get_all_items_in_background();

    items = await LocationModel.get_local_items();

    if (items == null || items.isEmpty) {
      items = await get_all_items_in_background();
    } else {
      return items;
    }
    return items;
  }

  static Future<List<LocationModel>> get_local_items() async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<LocationModel>("LocationModel");
    if (box.values.isEmpty) {
      return [];
    }

    List<LocationModel> items = [];
    box.values.forEach((element) {
      items.add(element);
    });

    return items;
  }

  static Future<List<LocationModel>> get_all_items_in_background() async {
    List<LocationModel> items = [];
    items = await get_online_items({'per_page': 10000});

    if (await Utils.is_connected()) {
      await LocationModel.save_to_local_db(items, true);
    }
    return items;
  }

  static Future<List<LocationModel>> get_online_items(
      Map<String, dynamic> data) async {
    List<LocationModel> items = [];

    String resp = await Utils.http_get('api/locations', data);

    if (resp != null && !resp.isEmpty) {
      json.decode(resp).map((element) {
        LocationModel item = new LocationModel();
        item = LocationModel.fromJson(element);
        items.add(item);
      }).toList();
    }

    return items;
  }

  static LocationModel fromJson(data) {
    LocationModel item = new LocationModel();

    item.id = 0;
    if (data['id'] != null) {
      try {
        item.id = int.parse(data['id'].toString());
      } catch (e) {
        item.id = 0;
      }
    }

    item.parent_id = Utils.int_parse(data['parent']);
    item.name = data['name'].toString();
    item.details = data['details'].toString();

    return item;
  }

  @HiveField(0)
  int id = 0;

  @HiveField(1)
  int parent_id = 0;

  @HiveField(2)
  String name = "";

  @HiveField(3)
  String longitude = "";

  @HiveField(4)
  String latitude = "";

  @HiveField(5)
  String details = "";

  @HiveField(6)
  String image = "";

  @HiveField(7)
  String type = "";

  @HiveField(8)
  String listed = "";

  static Future<void> save_to_local_db(
      List<LocationModel> data, bool clear_db) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = null;
    if (!Hive.isBoxOpen("LocationModel")) {
      box = await Hive.openBox<LocationModel>("LocationModel");
    }
    if (box == null) {
      box = await Hive.openBox<LocationModel>("LocationModel");
    }
    if (box == null) {
      return;
    }

    if (clear_db) {
      await box.clear();
    }
    box.addAll(data);
    return;
  }

  static Future<LocationModel> get_item(int id) async {
    LocationModel item = new LocationModel();

    (await get_all()).forEach((element) {
      if (element.id == id) {
        item = element;
      }
    });

    return item;
  }
}
