import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/extensions/string.dart';
import 'package:ict4farmers/extensions/widgets_extension.dart';
import 'package:ict4farmers/models/BannerModel.dart';
import 'package:ict4farmers/models/ProductModel.dart';
import 'package:ict4farmers/pages/TestPage1.dart';
import 'package:ict4farmers/pages/homes/select_language_dialog.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/theme/custom_theme.dart';
import 'package:ict4farmers/theme/theme_type.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:ict4farmers/widgets/images.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../TestPage.dart';
import 'app_setting_screen.dart';

class HomesScreenSegment extends StatefulWidget {
  HomesScreenSegment({Key? key}) : super(key: key);

  @override
  _HomesScreenSegmentState createState() => _HomesScreenSegmentState();
}

class _HomesScreenSegmentState extends State<HomesScreenSegment>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  late ThemeData theme;
  late CustomTheme customTheme;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  late TabController tabController;
  late List<NavItem> navItems;

  bool isDark = false;
  TextDirection textDirection = TextDirection.ltr;

  bool store_is_ready = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //_init_databse();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);

    navItems = [
      NavItem('Branding', Images.homeIcon, TestPage1(1)),
      NavItem('Printing', Images.app2Icon, TestPage1(2)),
      NavItem('Stationary', Images.materialDesignIcon, TestPage1(3)),
    ];

    tabController.addListener(() {
      currentIndex = tabController.index;

      setState(() {});
    });

    tabController.animation!.addListener(() {
      final aniValue = tabController.animation!.value;
      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
      }

      setState(() {});
    });
  }

  void changeDirection() {
    if (AppTheme.textDirection == TextDirection.ltr) {
      Provider.of<AppNotifier>(context, listen: false)
          .changeDirectionality(TextDirection.rtl);
    } else {
      Provider.of<AppNotifier>(context, listen: false)
          .changeDirectionality(TextDirection.ltr);
    }
    setState(() {});
  }

  void changeTheme() {
    if (AppTheme.themeType == ThemeType.light) {
      Provider.of<AppNotifier>(context, listen: false)
          .updateTheme(ThemeType.dark);
    } else {
      Provider.of<AppNotifier>(context, listen: false)
          .updateTheme(ThemeType.light);
    }

    setState(() {});
  }

  void launchCodecanyonURL() async {
    String url = "https://codecanyon.net/user/coderthemes/portfolio";
    //await launch(url);
  }

  void launchDocumentation() async {
    String url = "https://onekit.coderthemes.com/index.html";
    //await launch(url);
  }

  void launchChangeLog() async {
    String url = "https://onekit.coderthemes.com/changlog.html";
    //await launch(url);
  }

  List<ProductModel> items = [];


  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        isDark = AppTheme.themeType == ThemeType.dark;
        textDirection = AppTheme.textDirection;
        theme = AppTheme.theme;
        customTheme = AppTheme.customTheme;
        return Scaffold(
          key: _drawerKey,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),

            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image(
                    image: AssetImage(Images.logo_1),
                    width: 120,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, top: 7, bottom: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: theme.colorScheme.onBackground.withAlpha(20),
                  ),
                  width: 180,
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: theme.colorScheme.onBackground.withAlpha(200),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Search...",
                        style: TextStyle(
                          fontSize: 15,
                          color: theme.colorScheme.onBackground.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, SlideLeftRoute(AppSettingScreen()));
                  },
                  child: Container(
                    padding: FxSpacing.x(0),
                    child: Image(
                      image: AssetImage(Images.settingIcon),
                      color: theme.colorScheme.onBackground,
                      width: 26,
                      height: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              /* FxButton.text(
                  padding: FxSpacing.zero,
                  onPressed: () {
                    //print("one love");
                    //Utils.http_get('api/proudcts', {});
                  },
                  splashColor: CustomTheme.primary.withAlpha(40),
                  child:
                      FxText.b3("Forgot Password?", color: CustomTheme.accent)),*/

              /*Row(
                children: [
                  InkWell(
                    onTap: () => {_init_databse()},
                    child: Container(
                        color: Colors.green.shade200,
                        width: 100,
                        height: 100,
                        child: Text("Init Data")),
                  ),
                  InkWell(
                    onTap: () => {print("adding")},
                    child: Container(
                        color: Colors.blue.shade200,
                        width: 100,
                        height: 100,
                        child: Text("Add Data")),
                  ),
                  InkWell(
                    onTap: () => {_get_data()},
                    child: Container(
                        color: Colors.red.shade200,
                        width: 100,
                        height: 100,
                        child: Text("Read Data")),
                  ),
                ],
              ),*/
              FxContainer.none(
                padding: EdgeInsets.only(top: 10, bottom: 11),
                color: theme.scaffoldBackgroundColor,
                enableBorderRadius: false,
                borderRadiusAll: 0,
                child: TabBar(
                  labelPadding: EdgeInsets.all(0),
                  controller: tabController,
                  indicator: FxTabIndicator(
                      indicatorColor: CustomTheme.primary,
                      indicatorStyle: FxTabIndicatorStyle.rectangle,
                      indicatorHeight: 3,
                      radius: 0,
                      yOffset: 28,
                      width: 60),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: theme.colorScheme.primary,
                  tabs: buildTab(),
                ),
              ),
              Expanded(
                child: TabBarView(
                    controller: tabController,
                    children:
                    navItems.map((navItem) => navItem.screen).toList()),
              ),
            ],
          ),
/*          drawer: _buildDrawer(),*/
        );
      },
    );
  }

  Widget _buildDrawer() {
    return FxContainer.none(
      margin:
      FxSpacing.fromLTRB(16, FxSpacing.safeAreaTop(context) + 16, 16, 16),
      borderRadiusAll: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: theme.scaffoldBackgroundColor,
      child: Drawer(
          child: Container(
            color: theme.scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: FxSpacing.only(left: 20, bottom: 24, top: 24, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage(Images.brandLogo),
                        height: 102,
                        width: 102,
                      ),
                      FxSpacing.height(16),
                      FxContainer(
                        padding: FxSpacing.fromLTRB(12, 4, 12, 4),
                        borderRadiusAll: 4,
                        color: theme.colorScheme.primary.withAlpha(40),
                        child: FxText.caption("v. 9.2.0",
                            color: theme.colorScheme.primary,
                            fontWeight: 600,
                            letterSpacing: 0.2),
                      ),
                    ],
                  ),
                ),
                FxSpacing.height(32),
                Container(
                  margin: FxSpacing.x(20),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  SelectLanguageDialog());
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Row(
                          children: [
                            FxContainer(
                              paddingAll: 12,
                              borderRadiusAll: 4,
                              child: Image(
                                height: 20,
                                width: 20,
                                image: AssetImage(Images.languageOutline),
                                color: CustomTheme.peach,
                              ),
                              color: CustomTheme.peach.withAlpha(20),
                            ),
                            FxSpacing.width(16),
                            Expanded(
                              child: FxText.b1(
                                'language'.tr(),
                              ),
                            ),
                            FxSpacing.width(16),
                            Icon(
                              FeatherIcons.chevronRight,
                              size: 18,
                              color: theme.colorScheme.onBackground,
                            ).autoDirection(),
                          ],
                        ),
                      ),
                      FxSpacing.height(20),
                      InkWell(
                        onTap: () {
                          changeDirection();
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Row(
                          children: [
                            FxContainer(
                              paddingAll: 12,
                              borderRadiusAll: 4,
                              child: Image(
                                height: 20,
                                width: 20,
                                image: AssetImage(
                                    AppTheme.textDirection == TextDirection.ltr
                                        ? Images.paragraphRTLOutline
                                        : Images.paragraphLTROutline),
                                color: CustomTheme.skyBlue,
                              ),
                              color: CustomTheme.skyBlue.withAlpha(20),
                            ),
                            FxSpacing.width(16),
                            Expanded(
                              child: FxText.b1(
                                AppTheme.textDirection == TextDirection.ltr
                                    ? 'right_to_left'.tr() + " (RTL)"
                                    : 'left_to_right'.tr() + " (LTR)",
                              ),
                            ),
                            FxSpacing.width(16),
                            Icon(
                              FeatherIcons.chevronRight,
                              size: 18,
                              color: theme.colorScheme.onBackground,
                            ).autoDirection(),
                          ],
                        ),
                      ),
                      FxSpacing.height(20),
                      InkWell(
                        onTap: () {
                          changeTheme();
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Row(
                          children: [
                            FxContainer(
                              paddingAll: 12,
                              borderRadiusAll: 4,
                              color: CustomTheme.occur.withAlpha(20),
                              child: Image(
                                height: 20,
                                width: 20,
                                image: AssetImage(!isDark
                                    ? Images.darkModeOutline
                                    : Images.lightModeOutline),
                                color: CustomTheme.occur,
                              ),
                            ),
                            FxSpacing.width(16),
                            Expanded(
                              child: FxText.b1(
                                !isDark ? 'dark_mode'.tr() : 'light_mode'.tr(),
                              ),
                            ),
                            FxSpacing.width(16),
                            Icon(
                              FeatherIcons.chevronRight,
                              size: 18,
                              color: theme.colorScheme.onBackground,
                            ).autoDirection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FxSpacing.height(20),
                Divider(
                  thickness: 1,
                ),
                FxSpacing.height(16),
                Container(
                  margin: FxSpacing.x(20),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          launchDocumentation();
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Row(
                          children: [
                            FxContainer(
                              paddingAll: 12,
                              borderRadiusAll: 4,
                              child: Image(
                                height: 20,
                                width: 20,
                                image: AssetImage(Images.languageOutline),
                                color: CustomTheme.skyBlue,
                              ),
                              color: CustomTheme.skyBlue.withAlpha(20),
                            ),
                            FxSpacing.width(16),
                            Expanded(
                              child: FxText.b1(
                                'documentation'.tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FxSpacing.height(20),
                      InkWell(
                        onTap: () {
                          launchChangeLog();
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Row(
                          children: [
                            FxContainer(
                              paddingAll: 12,
                              borderRadiusAll: 4,
                              child: Image(
                                height: 20,
                                width: 20,
                                image: AssetImage(Images.changeLogIcon),
                                color: CustomTheme.peach,
                              ),
                              color: CustomTheme.peach.withAlpha(20),
                            ),
                            FxSpacing.width(16),
                            Expanded(
                              child: FxText.b1(
                                'changelog'.tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FxSpacing.height(20),
                Center(
                  child: FxButton(
                    borderRadiusAll: 4,
                    elevation: 0,
                    onPressed: () {
                      launchCodecanyonURL();
                    },
                    splashColor: theme.colorScheme.onPrimary.withAlpha(40),
                    child: FxText(
                      'buy_now'.tr(),
                      color: theme.colorScheme.onPrimary,
                    ),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                )
              ],
            ),
          )),
    );
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];

    for (int i = 0; i < navItems.length; i++) {
      tabs.add(Container(
          child: Text(
            navItems[i].title,
            style: TextStyle(
              fontSize: 15,
              color: (currentIndex == i)
                  ? CustomTheme.primary
                  : theme.colorScheme.onBackground.withAlpha(220),
            ),
          )));
    }
    return tabs;
  }
}

class NavItem {
  final String title;
  final String icon;
  final Widget screen;
  final double size;

  NavItem(this.title, this.icon, this.screen, [this.size = 28]);
}
