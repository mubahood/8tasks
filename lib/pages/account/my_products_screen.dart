import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/pages/account/single_appointment_screen.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/widget/my_widgets.dart';
import 'package:provider/provider.dart';

import '../../models/AppointmentModel.dart';
import '../../theme/app_notifier.dart';
import '../../utils/Utils.dart';
import '../../widget/empty_list.dart';
import '../../widget/shimmer_list_loading_widget.dart';

class MyProductsScreen extends StatefulWidget {
  @override
  State<MyProductsScreen> createState() => MyProductsScreenState();
}

late CustomTheme customTheme;
String title = "My Appointments";
bool is_loading = false;

class MyProductsScreenState extends State<MyProductsScreen> {
  final PageController pageController = PageController(initialPage: 0);
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    AppTheme.init();
    theme = AppTheme.theme;
    _do_refresh();
  }

  @override
  void dipose() {
    pageController.dispose();
  }

  UserModel userModel = new UserModel();
  List<AppointmentModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});
    userModel = await Utils.get_logged_in();
    if (userModel.id < 1) {
      setState(() {
        is_loading = false;
      });
      Utils.showSnackBar(
          "Login before you proceed.", _context, CustomTheme.primary);
      return;
    }

    items.clear();
    items = await AppointmentModel.get_items(
        params: {'client_id': userModel.id}, clear_previous: true);
    setState(() {
      is_loading = false;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: CustomTheme.primary,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: CustomTheme.primary,
              statusBarIconBrightness: Brightness.light,
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
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
              child: is_loading
                  ? ShimmerListLoadingWidget()
                  : RefreshIndicator(
                      onRefresh: _do_refresh,
                      color: CustomTheme.primary,
                      backgroundColor: Colors.white,
                      child: /*items.isEmpty
                          ? EmptyList(
                              body:
                                  "You have not placed any doctor appointment.",
                              action_text:
                                  "Press on the Plus (+) button to book a doctor.")
                          :*/ CustomScrollView(
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return Container(
                                        color: Colors.grey.shade200,
                                        padding: EdgeInsets.only(bottom: 3),
                                        child: SingleProduct(items[index]),
                                      );
                                    },
                                    childCount: items.length, // 1000 list items
                                  ),
                                )
                              ],
                            ))));
    });
  }

  Future<Null> _do_refresh() async {
    return await _onRefresh(context);
  }

  open_appointment_details(AppointmentModel item) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            AppointmentScreen(item),
        transitionDuration: Duration.zero,
      ),
    );
  }

  SingleProduct(AppointmentModel item) {
    return InkWell(
      onTap: () => {open_appointment_details(item)},
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FxContainer(
                        paddingAll: 0,
                        color: Colors.white,
                        borderRadiusAll: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FxText(
                              item.created_at,
                              maxLines: 1,
                              fontSize: 12,
                              fontWeight: 500,
                              color: Colors.grey.shade600,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: FxText(
                                item.hospital_name,
                                maxLines: 1,
                                fontSize: 18,
                                fontWeight: 500,
                                textAlign: TextAlign.start,
                                color: Colors.grey.shade800,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: FxText(
                          'USD ${item.price}',
                          maxLines: 1,
                          fontSize: 18,
                          fontWeight: 600,
                          textAlign: TextAlign.start,
                          color: Colors.grey.shade800,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 15),
              child: my_badge(
                  text: item.status,
                  type: (item.status == 'accepted')
                      ? 'success'
                      : (item.status == 'pending')
                          ? 'warning'
                          : (item.status == 'canceled')
                              ? 'danger'
                              : (item.status == 'completed')
                                  ? 'secondary'
                                  : ''),
            )
          ],
        ),
      ),
    );
  }
}
