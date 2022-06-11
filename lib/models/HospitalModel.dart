import 'dart:convert';

import 'package:ict4farmers/models/DynamicTable.dart';

class HospitalModel {
  int id = 0;
  String name = "";
  String photo = "";
  String details = "";
  String location_id = "";

  static String end_point = "hospitals";

  static Future<List<HospitalModel>> get_items({
    required Map<String, dynamic> params,
    required bool clear_previous,
  }) async {
    List<HospitalModel> items = [];
    List<DynamicTable> dynamic_items =
        await DynamicTable.get_local_items(endpoint: HospitalModel.end_point);

    if (dynamic_items.isEmpty) {
      await DynamicTable.get_items(
          end_point: HospitalModel.end_point,
          clear_previous: clear_previous,
          params: params);
      dynamic_items =
          await DynamicTable.get_local_items(endpoint: HospitalModel.end_point);
    } else {
      DynamicTable.get_items(
          end_point: HospitalModel.end_point,
          clear_previous: clear_previous,
          params: params);
    }

    dynamic_items.forEach((element) {
      HospitalModel item = new HospitalModel();
      item = HospitalModel.fromJson(element.data);
      items.add(item);
    });

    return items;
  }

  static HospitalModel fromJson(raw_data) {
    HospitalModel item = new HospitalModel();
    Map<String, dynamic> data = json.decode(raw_data.toString());
    item.id = 0;
    if (data['id'] != null) {
      try {
        item.id = int.parse(data['id'].toString());
      } catch (e) {
        item.id = 0;
      }
    }

    item.name = data['name'].toString();
    item.photo = data['photo'].toString();
    item.details = data['details'].toString();
    item.location_id = data['location_id'].toString();

    return item;
  }
}
