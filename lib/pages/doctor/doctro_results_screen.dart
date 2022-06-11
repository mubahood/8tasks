import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/widget/my_widgets.dart';
import 'package:provider/provider.dart';

import '../../models/ProductModel.dart';
import '../../theme/app_notifier.dart';
import '../../utils/Utils.dart';
import '../../widget/empty_list.dart';
import '../../widget/shimmer_loading_widget.dart';
import '../product_add_form/product_add_form.dart';

class DoctorResultsScreen extends StatefulWidget {
  @override
  State<DoctorResultsScreen> createState() =>
      DoctorResultsScreenState(this.lati, this.long, this.cat_id);
  double lati;
  double long;
  String cat_id;

  DoctorResultsScreen(this.lati, this.long, this.cat_id);
}

late CustomTheme customTheme;
bool is_loading = false;

class DoctorResultsScreenState extends State<DoctorResultsScreen> {
  DoctorResultsScreenState(this.lati, this.long, this.cat_id);

  double lati;
  double long;
  String cat_id;

  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    AppTheme.init();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    _do_refresh();
  }

  @override
  void dipose() {}

  UserModel userModel = new UserModel();
  List<ProductModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});

    items = await ProductModel.get_online_items({
      'lati': lati.toString(),
      'long': long.toString(),
      'cat_id': cat_id.toString(),
    });
    is_loading = false;
    setState(() {});
    return;

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

    items = await ProductModel.get_user_products(userModel.id);
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select doctor',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              /*FxButton.rounded(
                onPressed: () {
                  _do_refresh();
                },
                child: Icon(CupertinoIcons.refresh),
              )*/
            ],
          ),
          body: SafeArea(
              child: (is_loading)
                  ? Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(CustomTheme.primary),
                    ))
                  : RefreshIndicator(
                      onRefresh: _do_refresh,
                      color: CustomTheme.primary,
                      backgroundColor: Colors.white,
                      child: items.isEmpty
                          ? EmptyList(
                              body:
                                  "You have not placed any doctor appointment.",
                              action_text:
                                  "Press on the Plus (+) button to book a doctor")
                          : CustomScrollView(
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return Container(
                                        padding: EdgeInsets.all(10),
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

  UserModel logged_in_user = new UserModel();

  Future<Null> _do_refresh() async {
    logged_in_user = await Utils.get_logged_in();
    if (logged_in_user.id < 1) {
      show_not_account_bottom_sheet(context);
      return;
    }
    return await _onRefresh(context);
  }

  open_add_product(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductAddForm()),
    );

    if (result != null) {
      if (result['task'] != null) {
        if (result['task'] == 'success') {
          _do_refresh();
        }
      }
    }
  }

  SingleProduct(ProductModel item) {
    String thumbnail = AppConfig.BASE_URL + "/" + "no_image.jpg";

    if (item.thumbnail != null) {
      if (item.thumbnail.toString() != "null") {
        thumbnail = item.get_thumbnail().toString();
      }
    }

    double height = 130;
    return InkWell(
      onTap: () => {_show_bottom_sheet_product_actions(context, item)},
      child: Container(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                height: height,
                width: height,
                fit: BoxFit.cover,
                imageUrl: thumbnail,
                placeholder: (context, url) => ShimmerLoadingWidget(
                    height: 100, width: 100, is_circle: false, padding: 0),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: FxContainer(
                height: height,
                paddingAll: 0,
                margin: EdgeInsets.only(left: 10),
                color: Colors.white,
                width: double.infinity,
                borderRadiusAll: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.primary),
                    ),
                    FxText(
                      "Doctor: ....",
                      maxLines: 1,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    FxText(
                      "Location: .....  ",
                      maxLines: 1,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    ),
                    FxText(
                      "Service: .....",
                      maxLines: 1,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    ),
                    FxText(
                      "Price: USD ${item.price}",
                      maxLines: 1,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _show_bottom_sheet_product_actions(context, ProductModel item) {
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
                    SingleProduct(item),
                    Container(
                        margin: EdgeInsets.only(bottom: 5, top: 15),
                        child: FxButton(
                          elevation: 0,
                          padding: FxSpacing.all(12),
                          borderRadiusAll: 20,
                          onPressed: () {
                            submit_appointment(item);
                          },
                          child: FxText.l1(
                            "Gudbi balanta aad codsatay",
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: 700,
                            letterSpacing: 0.5,
                          ),
                          backgroundColor: CustomTheme.primary,
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> submit_appointment(ProductModel item) async {
    is_loading = true;
    setState(() {});
    Navigator.pop(context);
    String _resp = await Utils.http_post('api/appointments', {
      'product_id': item.id,
      'client_id': logged_in_user.id,
      'latitude': '${long}',
      'longitude': '${long}',
      'category_id': '${cat_id}',
      'details': 'Some details go here....',
    });

    is_loading = false;
    setState(() {});

    if (_resp == null || _resp.isEmpty) {
      Utils.showSnackBar(
          'Failed to connect to internet. Please check your network and try again.',
          context,
          CustomTheme.primary);
      return;
    }
    dynamic resp_obg = jsonDecode(_resp);
    print(resp_obg);
    if (resp_obg['status'].toString() != '1') {
      Utils.showSnackBar(
          resp_obg['message'].toString(), context, CustomTheme.primary);
      return;
    }

    Navigator.pop(context, {
      "success": '1',
    });
  }
}
