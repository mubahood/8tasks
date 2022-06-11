import 'dart:convert';

import 'package:ict4farmers/models/DynamicTable.dart';

import '../utils/AppConfig.dart';

class ServiceModel {
  int id = 0;

  String name = "";
  String category_id = "";
  String user_id = "";
  String price = "";
  String description = "";
  String thumbnail = "";
  String hospital_id = "";
  String doctor_id = "";
  String seller_name = "";

  static String end_point = "services";

  static Future<List<ServiceModel>> get_items({
    required Map<String, dynamic> params,
    required bool clear_previous,
  }) async {
    List<ServiceModel> items = [];
    List<DynamicTable> dynamic_items =
        await DynamicTable.get_local_items(endpoint: ServiceModel.end_point);

    if (dynamic_items.isEmpty) {
      await DynamicTable.get_items(
          end_point: ServiceModel.end_point,
          clear_previous: clear_previous,
          params: params);
      dynamic_items =
          await DynamicTable.get_local_items(endpoint: ServiceModel.end_point);
    } else {
      DynamicTable.get_items(
          end_point: ServiceModel.end_point,
          clear_previous: clear_previous,
          params: params);
    }

    dynamic_items.forEach((element) {
      ServiceModel item = new ServiceModel();
      item = ServiceModel.fromJson(element.data);
      items.add(item);
    });

    return items;
  }

  static ServiceModel fromJson(raw_data) {
    ServiceModel item = new ServiceModel();
    Map<String, dynamic> data = json.decode(raw_data.toString());
    item.id = 0;
    if (data['id'] != null) {
      try {
        item.id = int.parse(data['id'].toString());
      } catch (e) {
        item.id = 0;
      }
    }

    item.name = data['name'];
    item.category_id = data['category_id'].toString();
    item.user_id = data['user_id'].toString();
    item.price = data['price'].toString();
    item.description = data['description'].toString();
    item.thumbnail = data['thumbnail'].toString();
    item.hospital_id = data['hospital_id'].toString();
    item.doctor_id = data['doctor_id'].toString();
    item.seller_name = data['seller_name'].toString();

    return item;
  }


  String get_thumbnail() {
    String thumb = AppConfig.BASE_URL + "/" + "no_image.jpg";

    if(this.thumbnail!=null){
      return AppConfig.BASE_URL + "/storage/" + thumb.toString();
    }else{
      return thumb;
    }



  }
}
