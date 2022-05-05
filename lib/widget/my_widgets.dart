import 'package:flutter/material.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/utils/AppConfig.dart';

import '../theme/custom_theme.dart';
import '../utils/Utils.dart';

Widget my_badge({
  required String text,
  required String type,
}) {
  return FxContainer(
      child: Text(
        text,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: (type == 'success')
                ? Colors.green.shade800
                : (type == 'warning')
                    ? Colors.yellow.shade800
                    : (type == 'danger')
                        ? Colors.red.shade800
                        : Colors.grey.shade800),
      ),
      paddingAll: 5,
      color: (type == 'success')
          ? Colors.green.shade100
          : (type == 'warning')
              ? Colors.yellow.shade100
              : (type == 'danger')
                  ? Colors.red.shade100
                  : Colors.grey.shade100);
}

void show_appoinment_succcess_bottom_sheet(context) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext buildContext) {
        return DraggableScrollableSheet(
            initialChildSize: 0.75,
            //set this as you want
            maxChildSize: 0.75,
            //set this as you want
            minChildSize: 0.75,
            //set this as you want
            expand: true,
            builder: (context, scrollController) {
              return Container(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: SuccessWidget(context),
                ),
              );
            });
      });
}

void show_not_account_bottom_sheet(context) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext buildContext) {
        return DraggableScrollableSheet(
            initialChildSize: 0.75,
            //set this as you want
            maxChildSize: 0.75,
            //set this as you want
            minChildSize: 0.75,
            //set this as you want
            expand: true,
            builder: (context, scrollController) {
              return Container(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: NoAccountWidget(context),
                ),
              );
            });
      });
}

Widget SuccessWidget(BuildContext context,
    {String body:
        "THANK YOU!\n\n Your Doctor's Appointment submitted successfully .\n\n"
            "We are going to contact you as soon as possible!",
    String action_text: "",
    String empty_image: ""}) {
  String _empty_image = './assets/project/success.png';
  if (!empty_image.isEmpty) {
    _empty_image = empty_image;
  }
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: Image(
            image: AssetImage(
              _empty_image,
            ),
          ),
          padding: EdgeInsets.only(left: 100, right: 100),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              FxText(
                body,
                textAlign: TextAlign.center,
              ),
              FxSpacing.height(20),
              action_text.isEmpty
                  ? Container()
                  : FxText.h2(
                      action_text,
                      fontSize: 18,
                      color: CustomTheme.primary,
                      textAlign: TextAlign.center,
                    ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Divider(height: 10, color: CustomTheme.primary.withAlpha(40)),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(
            left: 40,
            right: 20,
          ),
          child: Row(
            children: [
              Expanded(
                  child: FxButton(
                elevation: 0,
                padding: FxSpacing.y(12),
                borderRadiusAll: 4,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: FxText.l1(
                  "OKAY!",
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                backgroundColor: CustomTheme.primary,
              )),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    ),
  );
}

Widget NoAccountWidget(BuildContext context,
    {String body: "You are not logged in yet.\n\n"
        "Create your ${AppConfig.AppName} account today! and make appointment with any doctor across Somalia!",
    String action_text: "",
    String empty_image: ""}) {
  String _empty_image = './assets/project/no_account.png';
  if (!empty_image.isEmpty) {
    _empty_image = empty_image;
  }
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: Image(
            image: AssetImage(
              _empty_image,
            ),
          ),
          padding: EdgeInsets.only(left: 80, right: 80),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              FxText(
                body,
                textAlign: TextAlign.center,
              ),
              FxSpacing.height(20),
              action_text.isEmpty
                  ? Container()
                  : FxText.h2(
                      action_text,
                      fontSize: 18,
                      color: CustomTheme.primary,
                      textAlign: TextAlign.center,
                    ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Divider(height: 10, color: CustomTheme.primary.withAlpha(40)),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(
            left: 40,
            right: 20,
          ),
          child: Row(
            children: [
              Expanded(
                  child: FxButton.outlined(
                borderRadiusAll: 10,
                borderColor: CustomTheme.accent,
                splashColor: CustomTheme.primary.withAlpha(40),
                padding: FxSpacing.y(12),
                onPressed: () {
                  Utils.navigate_to(AppConfig.AccountRegister, context);
                },
                child: FxText.l1(
                  "CREATE ACCOUNT",
                  color: CustomTheme.accent,
                  letterSpacing: 0.5,
                ),
              )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: FxButton(
                elevation: 0,
                padding: FxSpacing.y(12),
                borderRadiusAll: 4,
                onPressed: () {
                  Utils.navigate_to(AppConfig.AccountLogin, context);
                },
                child: FxText.l1(
                  "LOG IN",
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                backgroundColor: CustomTheme.primary,
              )),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    ),
  );
}

void my_bottom_sheet(context, Widget widget) {
  showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext buildContext) {
        return DraggableScrollableSheet(
            initialChildSize: 0.75,
            //set this as you want
            maxChildSize: 0.75,
            //set this as you want
            minChildSize: 0.75,
            //set this as you want
            expand: true,
            builder: (context, scrollController) {
              return Container(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: widget,
                ),
              );
            });
      });
}
