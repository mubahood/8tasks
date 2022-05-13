import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ict4farmers/models/BannerModel.dart';
import 'package:ict4farmers/models/ProductModel.dart';
import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/pages/HomPage.dart';
import 'package:ict4farmers/pages/account/account_register.dart';
import 'package:ict4farmers/pages/account/account_splash.dart';
import 'package:ict4farmers/pages/product_add_form/product_add_form.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/CategoryModel.dart';
import '../models/ChatModel.dart';
import '../models/DynamicTable.dart';
import '../models/FormItemModel.dart';
import '../models/LocationModel.dart';
import '../pages/account/account_details.dart';
import '../pages/account/account_edit.dart';
import '../pages/account/account_login.dart';
import '../pages/account/my_products_screen.dart';
import '../pages/account/onboarding_widget.dart';
import '../pages/chat/chat_screen.dart';
import '../pages/other_pages/about_is.dart';
import '../pages/other_pages/privacy_policy.dart';
import '../pages/other_pages/sell_fast.dart';
import '../pages/products/product_listting.dart';
import '../pages/products/view_full_images_screen.dart';
import 'AppConfig.dart';

class Utils {
  static void showSnackBar(String message, BuildContext _context, color,
      {background_color: Colors.green}) {
    if (Colors.green == background_color) {
      background_color = CustomTheme.primary;
    }
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: FxText.sh2(message, color: color),
        backgroundColor: background_color,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  static void bootstrap() async {
    await LocationModel.get_all();
  }

  static bool bool_parse(dynamic x) {
    int temp = 0;
    bool ans = false;
    try {
      temp = int.parse(x.toString());
    } catch (e) {
      temp = 0;
    }

    if (temp == 1) {
      ans = true;
    } else {
      ans = false;
    }
    return ans;
  }

  static Future<String> http_patch(
      String path, Map<String, dynamic> body) async {
    bool is_online = await Utils.is_connected();
    if (!is_online) {
      return "";
    }
    Response response;
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    var da = FormData.fromMap(body);
    try {
      response = await dio.patch("${AppConfig.BASE_URL}/${path}",
          data: da,
          options: Options(headers: <String, String>{
            "Content-Type": "application/json",
            "accept": "application/json",
          }));
      return jsonEncode(response.data);
    } catch (e) {
      return "";
    }

    return "";
  }

  static Future<String> http_post(
      String path, Map<String, dynamic> body) async {
    bool is_online = await Utils.is_connected();
    if (!is_online) {
      return "";
    }
    Response response;
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    var da = FormData.fromMap(body);
    try {
      response = await dio.post("${AppConfig.BASE_URL}/${path}",
          data: da,
          options: Options(headers: <String, String>{
            //"user": "${u.id}",
            "Content-Type": "application/json",
            "accept": "application/json",
          }));
      return jsonEncode(response.data);
    } catch (e) {
      print(e);
      return "";
    }

    return "";
  }

  static Future<bool> is_connected() async {
    bool is_connected = false;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      is_connected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      is_connected = true;
    }

    return is_connected;
  }

  static Future<String> http_get(String path, Map<String, dynamic> body) async {
    bool is_connected = await Utils.is_connected();

    if (!is_connected) {
      return "";
    }
    Response response;
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    var da = FormData.fromMap(body);
    //UserModel u = new UserModel();
    //u = await Utils.get_logged_user();

    try {
      response = await dio.get(AppConfig.BASE_URL + "/${path}",
          queryParameters: body,
          options: Options(headers: <String, String>{
            //"user": "${u.id}",
            "Content-Type": "application/json",
            "accept": "application/json",
          }));
    } catch (E) {
      print("FAILED BECAUSE  ====> ${E.toString()}");
      return "";
    }

    return jsonEncode(response.data);
  }

  static Future<dynamic> init_databse() async {
    if (!Hive.isAdapterRegistered(20)) {
      Hive.registerAdapter(BannerModelAdapter());
    }

    if (!Hive.isAdapterRegistered(30)) {
      Hive.registerAdapter(ProductModelAdapter());
    }

    if (!Hive.isAdapterRegistered(40)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    if (!Hive.isAdapterRegistered(50)) {
      Hive.registerAdapter(FormItemModelAdapter());
    }

    if (!Hive.isAdapterRegistered(51)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }
    if (!Hive.isAdapterRegistered(52)) {
      Hive.registerAdapter(LocationModelAdapter());
    }

    if (!Hive.isAdapterRegistered(55)) {
      Hive.registerAdapter(ChatModelAdapter());
    }

    if (!Hive.isAdapterRegistered(56)) {
      Hive.registerAdapter(DynamicTableAdapter());
    }
  }

  static navigate_to(String screen, context, {dynamic data: null}) {
    switch (screen) {
      case AppConfig.AccountDetails:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                AccountDetails(data),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.OnBoardingWidget:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                OnBoardingWidget(),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.ViewFullImagesScreen:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                ViewFullImagesScreen(data),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.AboutUs:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => AboutUs(),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.PrivacyPolicy:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PrivacyPolicy(),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.SellFast:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => SellFast(),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.ChatScreen:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ChatScreen(data),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.AccountLogin:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => AccountLogin(),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.AccountEdit:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => AccountEdit(),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.ProductListting:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProductListting(),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.MyProductsScreen:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MyProductsScreen(),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.ProductAddForm:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProductAddForm(),
            transitionDuration: Duration.zero,
          ),
        );
        break;

      case AppConfig.HomePage:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomePage(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case AppConfig.AccountRegister:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => AccountRegister(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case AppConfig.AccountSplash:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => AccountSplash(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
    }
  }

  static Future<bool> login_user(UserModel u) async {
    if (await is_login()) {
      await logged_out();
    }

    u.status = 'logged_in';
    u.status_comment = u.id.toString();

    var box = null;

    if (Hive.isBoxOpen('UserModel')) {
      box = await Hive.openBox<UserModel>("UserModel");
    }

    if (box == null) {
      return false;
    }

    box.add(u);

    return true;
  }

  static Future<bool> is_login() async {
    UserModel u = await get_logged_in();
    if (u == null) {
      return false;
    }
    if (u.id < 1) {
      return false;
    }

    if (u.status != 'logged_in') {
      return false;
    }

    return true;
  }

  static Future<UserModel> get_logged_in() async {
    UserModel u = new UserModel();
    List<UserModel> users = [];
    users = await get_local_users();
    if (users == null || users.isEmpty) {
      return u;
    }
    users.forEach((element) {
      if (element != null) {
        if (element.status == 'logged_in') {
          try {
            u.id = int.parse(element.status_comment);
          } catch (e) {
            u.id = 0;
          }
          u = element;
        }
      }
    });
    return u;
  }

  static Future<void> logged_out() async {
    List<UserModel> users = [];
    users = await get_local_users();

    users.forEach((element) {
      if (element != null) {
        if (element.status == 'logged_in') {
          element.delete();
        }
      }
    });
  }

  static Future<List<UserModel>> get_local_users() async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<UserModel>("UserModel");
    if (box.values.isEmpty) {
      return [];
    }

    List<UserModel> items = [];
    box.values.forEach((element) {
      items.add(element);
    });

    return items;
  }

  static void launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  static void launchPhone(String phone_number) async {
    if (!await launch('tel:${phone_number}'))
      throw 'Could not launch $phone_number';
  }

//
  static void launchOuLink(String link) async {
    if (link == AppConfig.CallUs) {
      Utils.launchPhone(AppConfig.OUR_PHONE_NUMBER);
    } else if (link == AppConfig.OurWhatsApp) {
      Utils.launchURL(
          'https://wa.me/${AppConfig.OUR_WHATSAPP_NUMBER}?text=Hi, I am contacting you from go ${AppConfig.AppName}.\n\n');
    } else {
      Utils.launchURL(link);
    }
  }

  static Future<Position> get_device_location() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

    }

    Position p = await Geolocator.getCurrentPosition();
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
