import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/utils/spacing.dart';
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

class ProductListting extends StatefulWidget {
  @override
  State<ProductListting> createState() => _ProductListtingState();
}

List<BannerModel> banners = [];
bool initilized = false;
bool store_initilized = false;

class _ProductListtingState extends State<ProductListting> {
  _ProductListtingState();

  @override
  void initState() {
    _onRefresh();
  }

  @override
  void dipose() {}

  List<ProductModel> _products = [];
  int i = 0;

  Future<Null> _onRefresh() async {
    _products = await ProductModel.get_local_products();
    _products.shuffle();


    setState(() {});
    initilized = false;
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
              elevation: 1,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "Products",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        padding: FxSpacing.x(0), child: Icon(Icons.sort)),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: CustomScrollView(
                    slivers: [
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                                mainAxisExtent: 300),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ProductItemUi(index,_products[index],context);
                          },
                          childCount: _products.length,
                        ),
                      ),
                    ],
                  )),
            ));
      },
    );
  }


}
