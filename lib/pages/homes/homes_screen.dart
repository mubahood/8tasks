import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/pages/account/account_splash.dart';
import 'package:ict4farmers/pages/homes/homes_screen_segment.dart';
import 'package:ict4farmers/theme/app_notifier.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/theme/custom_theme.dart';
import 'package:ict4farmers/theme/theme_type.dart';
import 'package:ict4farmers/widgets/images.dart';
import 'package:ict4farmers/widgets/svg.dart';
import 'package:provider/provider.dart';

import '../account/my_products_screen.dart';
import '../chat/chat_home_screen.dart';
import '../doctor/book_doctor.dart';
import 'on_map/on_map_screen.dart';

class HomesScreen extends StatefulWidget {
  HomesScreen({Key? key}) : super(key: key);

  @override
  _HomesScreenState createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  late ThemeData theme;
  late CustomTheme customTheme;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  late TabController tabController;
  late List<NavItem> navItems;

  bool isDark = false;
  TextDirection textDirection = TextDirection.ltr;

  @override
  void initState() {
    super.initState();
    AppTheme.init();

    navItems = [
      NavItem('Book Doctor', Images.svg_home, BookDoctorScreen()),
      NavItem('Appointments', Images.svg_category, MyProductsScreen()),
      NavItem('Account', Images.svg_user, AccountSplash()),
    ];


    tabController = TabController(
        //       animationDuration: Duration.zero,
        length: navItems.length,
        vsync: this,
        initialIndex: 0);



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
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children:
                        navItems.map((navItem) => navItem.screen).toList()),
              ),
              FxContainer.none(
                padding: FxSpacing.xy(0, 2),
                color: theme.scaffoldBackgroundColor,
                bordered: true,
                enableBorderRadius: false,
                borderRadiusAll: 0,
                border: Border(
                  top: BorderSide(width: 2, color: customTheme.border),
                ),
                child: TabBar(
                  labelPadding: EdgeInsets.all(0),
                  controller: tabController,
                  indicator: FxTabIndicator(
                      indicatorColor: CustomTheme.primary,
                      indicatorStyle: FxTabIndicatorStyle.rectangle,
                      indicatorHeight: 2,
                      radius: 4,
                      yOffset: -4,
                      width: 35),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: CustomTheme.primary,
                  tabs: buildTab(),
                ),
              ),
            ],
          ),
/*          drawer: _buildDrawer(),*/
        );
      },
    );
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];

    for (int i = 0; i < navItems.length; i++) {
      tabs.add(Container(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 2, top: 2),
            child: SVG(navItems[i].icon,
                color: (currentIndex == i)
                    ? CustomTheme.primary
                    : theme.colorScheme.onBackground.withAlpha(220),
                size: 23),
          ),
          FxText.b1(
            navItems[i].title,
            style: TextStyle(
              color: (currentIndex == i)
                  ? CustomTheme.primary
                  : theme.colorScheme.onBackground.withAlpha(220),
            ),
          )
        ],
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
