import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../models/AppointmentModel.dart';
import '../../theme/app_notifier.dart';
import '../../utils/Utils.dart';
import 'appoitnment_admin_screen.dart';

class AppointmentScreen extends StatefulWidget {
  AppointmentModel item;

  AppointmentScreen(this.item);

  @override
  State<AppointmentScreen> createState() => AppointmentScreenState(this.item);
}

late CustomTheme customTheme;
String title = "Appointment details";

class AppointmentScreenState extends State<AppointmentScreen> {
  AppointmentModel item;

  AppointmentScreenState(this.item);

  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    AppTheme.init();
    theme = AppTheme.theme;
    _do_refresh();
  }

  UserModel userModel = new UserModel();

  Future<Null> _onRefresh(BuildContext _context) async {
    setState(() {});
    userModel = await Utils.get_logged_in();
    if (userModel.id < 1) {
      setState(() {});
      Utils.showSnackBar(
          "Login before you proceed.", _context, CustomTheme.primary);
      return;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            elevation: 1,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
              child: ListView(
            children: [
              FxContainer(
                color: Colors.white,
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.h6(
                      "Appointment",
                      fontWeight: 600,
                    ),
                    singleItem(title: "Service", details: item.details),
                    singleItem(title: "Hospital", details: item.hospital_name),
                    singleItem(title: "Doctor", details: item.doctor.name),
                    singleItem(title: "Placed", details: item.created_at),
                    singleItem(title: "Status", details: item.status),
                    singleItem(
                        title: "Appointment time",
                        details: (item.appointment_time.isEmpty)
                            ? "-"
                            : item.appointment_time),
                    Divider(
                      height: 30,
                      thickness: 5,
                    ),
                    FxText.h6(
                      "Client",
                      fontWeight: 600,
                    ),
                    singleItem(title: "Name", details: item.client.name),
                    singleItem(
                        title: "Contact", details: item.client.phone_number),
                    singleItem(title: "Address", details: item.client.address),
                    Divider(
                      height: 30,
                      thickness: 5,
                    ),
                    FxText.h6(
                      "Payment",
                      fontWeight: 600,
                    ),
                    singleItem(
                        title: "Status",
                        details: item.payment_status.toString()),
                    singleItem(title: "Amount", details: item.price),
                    singleItem(
                        title: "Method",
                        details: item.payment_method.toString()),
                    Divider(
                      height: 30,
                      thickness: 5,
                    ),
                    FxButton.block(
                      elevation: 0,
                      backgroundColor: CustomTheme.primary,
                      borderRadiusAll: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FxText.caption("DO ACTION",
                              letterSpacing: 0.3,
                              fontWeight: 700,
                              fontSize: 18,
                              color: CustomTheme.onPrimary)
                        ],
                      ),
                      onPressed: () {
                        open_do_action(item);
                      },
                    )
                  ],
                ),
              ),
            ],
          )));
    });
  }

  open_do_action(AppointmentModel item) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            AppointmentAdminScreen(item),
        transitionDuration: Duration.zero,
      ),
    );
  }

  Future<Null> _do_refresh() async {
    return await _onRefresh(context);
  }

  Widget singleItem({required String title, required String details}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FxText.b1(title),
          ),
          FxText.b1(": "),
          Expanded(
            child: FxText.b1(
              details,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
