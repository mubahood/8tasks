import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/widgets/images.dart';
import 'package:provider/provider.dart';

import '../../models/BannerModel.dart';
import '../../models/ProductModel.dart';
import '../../theme/app_notifier.dart';
import '../../utils/Utils.dart';
import '../../widget/product_item_ui.dart';
import '../../widget/shimmer_loading_widget.dart';

class ItemPickerScreen extends StatefulWidget {
  List<String> _items;
  String _title;

  ItemPickerScreen(this._items, this._title);

  @override
  State<ItemPickerScreen> createState() =>
      _ItemPickerScreenState(this._items, this._title);
}

List<BannerModel> banners = [];
bool initilized = false;
bool store_initilized = false;

class _ItemPickerScreenState extends State<ItemPickerScreen> {
  _ItemPickerScreenState(this._items, this._title);

  @override
  void initState() {
    init_data();
  }

  @override
  void dipose() {}

  List<String> _items;
  String _title;
  int i = 0;

  Future<Null> _onRefresh() async {
    _items.sort();
    setState(() {});
    return null;
  }

  bool isDark = false;

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
                    child: Text(
                      _title,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        padding: FxSpacing.x(0), child: Icon(Icons.done)),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return single_item(index, _items[index], context);
                      },
                      childCount: _items.length,
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget single_item(int index, String item, BuildContext context) {
    return FxContainer(
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, top: 7, bottom: 7),
      child: Row(
        children: [
          InkWell(
            onTap: _onTap(item),
            child: FxContainer(
              width: 35,
              alignment: Alignment.center,
              borderRadiusAll: 17,
              height: 35,
              child: FxText(
                "${index + 1}",
                color: Colors.white,
              ),
              color: CustomTheme.primary,
              paddingAll: 0,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          FxContainer(
              paddingAll: 0, color: Colors.white, child: FxText("${item}")),
        ],
      ),
    );
  }

  void init_data() {
    _onRefresh();
  }

  _onTap(String item) {
    Navigator.pop(context, {'value': item});
    return;
  }
}
