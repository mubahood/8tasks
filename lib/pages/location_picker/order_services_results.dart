import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/models/ServiceModel.dart';
import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:provider/provider.dart';

import '../../models/ServiceModel.dart';
import '../../theme/app_notifier.dart';
import '../../utils/Utils.dart';
import '../../widget/empty_list.dart';
import '../product_add_form/product_add_form.dart';

class OrderServicesResults extends StatefulWidget {
  @override
  State<OrderServicesResults> createState() => OrderServices_resuRsState();

  int hospital_id;

  OrderServicesResults(this.hospital_id);
}

late CustomTheme customTheme;
bool is_loading = false;

class OrderServices_resuRsState extends State<OrderServicesResults> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    _do_refresh();
    AppTheme.init();
  }

  @override
  void dipose() {}

  UserModel userModel = new UserModel();
  List<ServiceModel> items = [];
  List<ServiceModel> _items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});

    _items = await ServiceModel.get_items(params: {}, clear_previous: false);
    is_loading = false;

    _items.forEach((element) {
      if (widget.hospital_id.toString() == element.hospital_id.toString()) {
        items.add(element);
      }
    });
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
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'Dooro adeegaa rabto.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
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
                              body: "Adeegan hada kamajiro Isbitaalkaan.",
                              action_text: "Fadlan dooro Isbitaalkale.")
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

  SingleProduct(ServiceModel item) {
    String thumbnail = AppConfig.BASE_URL + "/" + "no_image.jpg";

    if (item.thumbnail != null) {
      if (item.thumbnail.toString() != "null") {
        thumbnail = item.get_thumbnail().toString();
      }
    }

    double height = 130;
    return InkWell(
      onTap: () => {_show_bottom_sheet_product_actions(context, item)},
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                /*ClipRRect(
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
                ),*/
                Flexible(
                  child: FxContainer(
                    height: height,
                    paddingAll: 0,
                    margin: EdgeInsets.only(left: 10),
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
                          "Price: USD ${item.price}",
                          maxLines: 1,
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        FxText(
                          item.description,
                          maxLines: 3,
                          height: 1,
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w300,
                              fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          FxDashedDivider(
            color: Colors.grey.shade500,
          ),
        ],
      ),
    );
  }

  ConfirmProductModal(ServiceModel item) {
    String thumbnail = AppConfig.BASE_URL + "/" + "no_image.jpg";

    if (item.thumbnail != null) {
      if (item.thumbnail.toString() != "null") {
        thumbnail = item.get_thumbnail().toString();
      }
    }

    double height = 130;
    return Container(
      child: Row(
        children: [
          /* ClipRRect(
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
          ),*/
          Flexible(
            child: FxContainer(
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
                    "Price: USD ${item.price}",
                    maxLines: 1,
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  FxText(
                    item.description,
                    maxLines: 10,
                    height: 1,
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _show_bottom_sheet_product_actions(context, ServiceModel item) {
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
                    ConfirmProductModal(item),
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
                            "XAQIIJIN BAALINTA",
                            color: Colors.white,
                            fontSize: 25,
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

  Future<void> submit_appointment(ServiceModel item) async {
    Utils.navigate_to(AppConfig.AccountRegister, context, data: {
      'id': item.id,
      'msg': 'SERVICE: ${item.name}\nPRICE: USD ${item.price}'
    });
    return;
    is_loading = true;
    setState(() {});
    Navigator.pop(context);
    String _resp = await Utils.http_post('api/appointments', {
      'product_id': item.id,
      'client_id': logged_in_user.id,
      'details': 'Some details go here....',
      'latitude': '0.00',
      'longitude': '0.00',
      'category_id': '${item.category_id}',
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
    if (resp_obg['status'].toString() != '1') {
      Utils.showSnackBar(
          resp_obg['message'].toString(), context, CustomTheme.primary);
      return;
    }
    Utils.navigate_to(AppConfig.PaymentPage, context);
  }
}
