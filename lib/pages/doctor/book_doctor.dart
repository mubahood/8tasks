import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ict4farmers/pages/doctor/doctro_results_screen.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:ict4farmers/widgets/images.dart';
import 'package:provider/provider.dart';

import '../../widget/my_widgets.dart';
import '../location_picker/product_category_picker.dart';

class BookDoctorScreen extends StatefulWidget {
  @override
  ABookDoctorScreenState createState() => ABookDoctorScreenState();
}

class ABookDoctorScreenState extends State<BookDoctorScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  bool is_loading = true;
  bool is_logged_in = true;

  @override
  void initState() {
    super.initState();
    get_location();
    check_login();

    FxTextStyle.changeFontFamily(GoogleFonts.roboto);
    FxTextStyle.changeDefaultFontWeight({
      100: FontWeight.w100,
      200: FontWeight.w200,
      300: FontWeight.w300,
      400: FontWeight.w400,
      500: FontWeight.w500,
      600: FontWeight.w600,
      700: FontWeight.w700,
      800: FontWeight.w800,
      900: FontWeight.w900,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      theme = AppTheme.theme;
      customTheme = AppTheme.customTheme;

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
            colorScheme: theme.colorScheme
                .copyWith(secondary: customTheme.cookifyPrimary.withAlpha(40))),
        home: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Image.asset(
                    Images.doctor,
                    width: (MediaQuery.of(context).size.width / 1.8),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: FxButton.outlined(
                  borderColor: CustomTheme.primary,
                  borderRadiusAll: 11,
                  splashColor: CustomTheme.primary.withAlpha(40),
                  padding:
                      FxSpacing.only(left: 20, top: 10, bottom: 10, right: 20),
                  onPressed: () {
                    book_doctor();

                    //open_doctor_results();
                    //pick_category();
                    //Utils.navigate_to(AppConfig.AccountRegister, context);
                  },
                  child: FxText.l1(
                    "Book A Doctor",
                    fontSize: 30,
                    color: CustomTheme.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  String category_id = "";
  String category_text = "";

  Future<void> open_doctor_results() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DoctorResultsScreen(lati, long, category_id)),
    );

    if (result != null) {
      if ((result['success'] != null) &&
          (!result['success'].toString().isEmpty)) {
        show_appoinment_succcess_bottom_sheet(context);
      }
    }
  }

  Future<void> pick_category() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductCategoryPicker()),
    );

    if (result != null) {
      if ((result['category_id'] != null) &&
          (result['category_text'] != null)) {
        category_id = result['category_id'];
        category_text = result['category_text'];
        setState(() {});
        open_doctor_results();
      }
    }
  }

  double lati = 0;
  double long = 0;

  void check_login() async {
    is_loading = true;
    is_logged_in = await Utils.is_login();
    setState(() {
      is_loading = false;
    });
  }

  Future<void> get_location() async {
    Position p = await Utils.get_device_location();
    if (p != null) {
      lati = p.latitude;
      long = p.longitude;
    }
  }

  Future<void> book_doctor() async {
    if (lati == 0 && long == 0) {
      await get_location();
    }

    if (lati == 0 && long == 0) {
      Utils.showSnackBar(
          "You must enable your location to proceed.", context, Colors.red);
      return;
    }
    check_login();
    if (!is_logged_in) {
      show_not_account_bottom_sheet(context);
      return;
    }

    pick_category();
  }
}
