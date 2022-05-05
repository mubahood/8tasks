/*
* File : Custom Onboarding
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';

class OnBoardingWidget extends StatefulWidget {
  @override
  _OnBoardingWidgetState createState() => _OnBoardingWidgetState();
}

class _OnBoardingWidgetState extends State<OnBoardingWidget> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
            colorScheme: theme.colorScheme
                .copyWith(secondary: CustomTheme.primary.withAlpha(40))),
        home: Scaffold(
            body: Container(
                child: FxOnBoarding(
          pages: <PageViewModel>[
            single_page_item(
                title: "Welcome",
                subtitle:
                    "Monitor local weather blah blah blah blah blah blah blah blah blah...",
                image: "./assets/project/on_board_weather.png"),
            single_page_item(
                title: "Buy and sell",
                subtitle:
                    "blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah...",
                image: "./assets/project/on_board_forum.png"),
            single_page_item(
                title: "Much More",
                subtitle:
                    "blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah...",
                image: "./assets/project/on_board_toll_free.png"),
          ],
          unSelectedIndicatorColor: CustomTheme.primary,
          selectedIndicatorColor: CustomTheme.accent,
          doneWidget: InkWell(
            splashColor: CustomTheme.primary,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/HomesScreen", (r) => false);
              //Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: FxText.sh2("DONE!".toUpperCase(),
                  color: CustomTheme.primary,
                  fontWeight: 700,
                  letterSpacing: 0.6),
            ),
          ),
          skipWidget:
              SizedBox() /* InkWell(
            splashColor: CustomTheme.primary,
            onTap: () {
              //Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: FxText.sh2("Next".toUpperCase(),
                  color: CustomTheme.primary,
                  fontWeight: 700,
                  letterSpacing: 0.6),
            ),
          )*/
          ,
        ))));
  }

  PageViewModel single_page_item({
    String title: "Welcome",
    String subtitle: "Welcome",
    String image: "./assets/project/on_board_welcome.png",
  }) {
    return PageViewModel(
      theme.backgroundColor,
      Padding(
        padding: EdgeInsets.only(left: 20.0, right: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Center(
              child: Image(
                  height: (MediaQuery.of(context).size.height / 2.5),
                  image: AssetImage(image),
                  fit: BoxFit.scaleDown),
            ),
            SizedBox(height: 10.0),
            FxText.b1(title,
                color: CustomTheme.primary,
                letterSpacing: 0.2,
                fontSize: 30,
                fontWeight: 700),
            SizedBox(height: 15.0),
            FxText.b2('$subtitle',
                color: theme.colorScheme.onBackground.withAlpha(200),
                letterSpacing: 0.1,
                fontWeight: 500),
          ],
        ),
      ),
    );
  }
}
