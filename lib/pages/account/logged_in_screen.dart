import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/models/ChatModel.dart';
import 'package:ict4farmers/models/FormItemModel.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../models/UserModel.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../widget/shimmer_loading_widget.dart';
import '../product_add_form/product_add_form.dart';

class LoggedInScreen extends StatefulWidget {
  ThemeData theme;
  BuildContext _context;

  LoggedInScreen(this.theme, this._context);

  @override
  LoggedInScreenState createState() =>
      LoggedInScreenState(this.theme, _context);
}

class LoggedInScreenState extends State<LoggedInScreen> {
  ThemeData theme;
  BuildContext _context;
  UserModel logged_in_user = new UserModel();

  LoggedInScreenState(this.theme, this._context);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    my_init();
  }

  bool _has_pending_form = false;
  List<ChatModel> chat_threads = [];

  Future<void> my_init() async {
    logged_in_user = await Utils.get_logged_in();
    if (logged_in_user.id < 1) {
      Utils.showSnackBar("Login before you proceed.", _context, Colors.red);
      return;
    }
    chat_threads = await ChatModel.get_threads(logged_in_user.id);
    await check_daft_form();
    setState(() {});
  }

  Future<void> check_daft_form() async {
    if ((await FormItemModel.get_all()).isEmpty) {
      _has_pending_form = false;
    } else {
      _has_pending_form = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:
          FxSpacing.fromLTRB(20, FxSpacing.safeAreaTop(_context) + 20, 20, 20),
      children: <Widget>[
        Column(
          children: <Widget>[
            FxContainer.rounded(
              paddingAll: 0,
              width: 100,
              height: 100,
              child: CachedNetworkImage(
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                imageUrl: logged_in_user.avatar,
                placeholder: (context, url) => ShimmerLoadingWidget(
                  height: 100,
                  width: 100,
                ),
                errorWidget: (context, url, error) => Image(
                  image: AssetImage('./assets/project/no_image.jpg'),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            FxSpacing.height(8),
            FxText.sh1(logged_in_user.name, fontWeight: 600, letterSpacing: 0),
          ],
        ),
        FxSpacing.height(24),
        Column(
          children: <Widget>[
             
            Divider(),
            singleOption(_context, theme,
                iconData: MdiIcons.shapeOutline,
                option: "My Appointments",
                navigation: ''),
            Divider(),
            singleOption(_context, theme,
                iconData: Icons.manage_accounts,
                option: "My Profile",
                navigation: AppConfig.AccountEdit),
            Divider(),
            singleOption(_context, theme,
                iconData: Icons.access_alarm_outlined,
                option: "Health tips",
                navigation: AppConfig.SellFast),
            Divider(),
            singleOption(_context, theme,
                iconData: MdiIcons.creditCardOutline,
                option: "About ${AppConfig.AppName}",
                navigation: AppConfig.AboutUs),
            Divider(),
            singleOption(_context, theme,
                iconData: MdiIcons.faceAgent,
                option: "Help \& Support",
                navigation: AppConfig.CallUs),
            Divider(),

            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () => {Utils.launchOuLink(AppConfig.OurWhatsApp)},
                    child: Container(
                      margin: EdgeInsets.only(left: 0),
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        Icons.whatsapp,
                        size: 30,
                        color: Colors.green.shade600,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade500, width: 1),
                          color: AppTheme.lightTheme.backgroundColor,
                          borderRadius:
                          BorderRadius.all(Radius.circular(11))),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                    {Utils.launchOuLink(AppConfig.OUR_FACEBOOK_LINK)},
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        Icons.facebook,
                        size: 30,
                        color: Colors.blue.shade800,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade500, width: 1),
                          color: AppTheme.lightTheme.backgroundColor,
                          borderRadius:
                          BorderRadius.all(Radius.circular(11))),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                    {Utils.launchOuLink(AppConfig.OUR_TWITTER_LINK)},
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        MdiIcons.twitter,
                        size: 30,
                        color: Colors.blue.shade500,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade500, width: 1),
                          borderRadius:
                          BorderRadius.all(Radius.circular(11))),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                    {Utils.launchOuLink(AppConfig.OUR_INSTAGRAM_LINK)},
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        MdiIcons.instagram,
                        size: 30,
                        color: Colors.purple.shade300,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade500, width: 1),
                          borderRadius:
                          BorderRadius.all(Radius.circular(11))),
                    ),
                  ),

                ],
              ),
            ),

            FxSpacing.height(24),

            Center(
              child: FxButton(
                elevation: 0,
                backgroundColor: CustomTheme.primary,
                borderRadiusAll: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      MdiIcons.logoutVariant,
                      color: CustomTheme.onPrimary,
                      size: 18,
                    ),
                    FxSpacing.width(16),
                    FxText.caption("LOGOUT",
                        letterSpacing: 0.3,
                        fontWeight: 600,
                        color: CustomTheme.onPrimary)
                  ],
                ),
                onPressed: () {
                  do_logout();
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  void _show_bottom_sheet_sell_or_buy(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () => {open_add_product(context)},
                      dense: false,
                      leading: Icon(Icons.sell,
                          color: theme.colorScheme.onBackground),
                      title: FxText.b1("Sell something", fontWeight: 600),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () => {open_add_product(context)},
                        leading: Icon(Icons.campaign,
                            color: theme.colorScheme.onBackground),
                        title: FxText.b1("Look for something to buy",
                            fontWeight: 600)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget singleOption(_context, theme,
      {IconData? iconData,
      required String option,
      String navigation: "",
      String badge: ""}) {
    return Container(
      padding: FxSpacing.y(8),
      child: InkWell(
        onTap: () {
          //print("======> ${logged_in_user.avatar}");
          //return;
          //Utils.navigate_to(AppConfig.MyProductsScreen, _context);
          //return;
          if (navigation == AppConfig.CallUs) {
            Utils.launchOuLink(navigation);
          } else if (navigation == AppConfig.ProductAddForm) {
            Utils.navigate_to(navigation, _context);
            //_show_bottom_sheet_sell_or_buy(_context);
          } else {
            Utils.navigate_to(navigation, _context);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(
                iconData,
                size: 22,
                color: theme.colorScheme.onBackground,
              ),
            ),
            FxSpacing.width(16),
            Expanded(
              child: FxText.b1(option, fontWeight: 600),
            ),
            Container(
              child: Row(
                children: [
                  badge.toString().isEmpty
                      ? SizedBox()
                      : FxContainer(
                          color: Colors.red.shade500,
                          width: 28,
                          paddingAll: 0,
                          marginAll: 0,
                          alignment: Alignment.center,
                          borderRadiusAll: 15,
                          height: 28,
                          child: FxText(
                            badge.toString(),
                            color: Colors.white,
                          )),
                  Icon(MdiIcons.chevronRight,
                      size: 22, color: theme.colorScheme.onBackground),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> do_logout() async {
    await Utils.logged_out();
    Utils.showSnackBar(
        "Logged out successfully.", _context, Colors.white);
    my_init();
  }

  open_add_product(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductAddForm()),
    );

    if (result != null) {
      if (result['task'] != null) {
        if (result['task'] == 'success') {
          Utils.navigate_to(AppConfig.MyProductsScreen, context);
        }
      }
    }
  }
}
