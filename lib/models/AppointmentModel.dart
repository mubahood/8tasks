import 'dart:convert';

import 'package:ict4farmers/models/DynamicTable.dart';
import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/utils/Utils.dart';

class AppointmentModel {
  int id = 0;
  String created_at = "";
  int hospital_id = 0;
  int doctor_id = 0;
  int client_id = 0;
  String status = "";
  String payment_method = "";
  String payment_status = "";
  String price = "";
  String latitude = "";
  String longitude = "";
  String order_location = "";
  String category_id = "";
  String appointment_time = "";
  String details = "";

  String hospital_name = "";
  String hospital_location_id = "";
  String hospital_photo = "";
  String hospital_details = "";
  String hospital_latitude = "";
  String hospital_longitude = "";

  UserModel client = new UserModel();
  UserModel doctor = new UserModel();
  static String end_point = "appointments";

  static Future<List<AppointmentModel>> get_items({
    required Map<String, dynamic> params,
    required bool clear_previous,
  }) async {
    List<AppointmentModel> items = [];
    List<DynamicTable> dynamic_items = await DynamicTable.get_items(
        end_point: AppointmentModel.end_point,params: params, clear_previous: true);



    if (dynamic_items.isEmpty) {
      await DynamicTable.get_items(
          end_point: AppointmentModel.end_point,
          clear_previous: clear_previous,
          params: params);
      dynamic_items = await DynamicTable.get_local_items(
          endpoint: AppointmentModel.end_point);
    } else {
      DynamicTable.get_items(
          end_point: AppointmentModel.end_point,
          clear_previous: clear_previous,
          params: params);
    }

    dynamic_items.forEach((element) {
      AppointmentModel item = new AppointmentModel();
      item = AppointmentModel.fromJson(element.data);
      items.add(item);
    });

    return items;
  }

  static AppointmentModel fromJson(raw_data) {
    AppointmentModel item = new AppointmentModel();
    Map<String, dynamic> data = json.decode(raw_data.toString());
    item.id = 0;
    if (data['id'] != null) {
      try {
        item.id = int.parse(data['id'].toString());
      } catch (e) {
        item.id = 0;
      }
    }

    item.price = data['price'];
    item.created_at = data['created_at'];
    item.hospital_id = Utils.int_parse(data['hospital_id']);
    item.payment_method = data['payment_method'].toString();
    item.payment_status = data['payment_status'].toString();
    item.doctor_id = Utils.int_parse(data['doctor_id']);
    item.client_id = Utils.int_parse(data['client_id']);
    item.status = data['status'];
    item.price = data['price'];
    item.latitude = data['latitude'].toString();
    item.longitude = data['longitude'].toString();
    item.order_location = data['order_location'].toString();
    item.category_id = data['category_id'].toString();
    item.appointment_time = data['appointment_time'].toString();
    item.details = data['details'].toString();
/*    item.client = UserModel.fromMap(data['client']);
    item.doctor = UserModel.fromMap(data['doctor']);*/
    item.hospital_name = data['hospital']['name'];
    item.hospital_location_id = data['hospital']['location_id'].toString();
 /*   item.hospital_photo = data['hospital']['photo'];
    item.hospital_details = data['hospital']['details'];
    item.hospital_latitude = data['hospital']['latitude'];
    item.hospital_longitude = data['hospital']['longitude'];*/

    return item;
  }
}
