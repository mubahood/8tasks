import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:ict4farmers/pages/products/product_listting.dart';
import 'package:ict4farmers/utils/AppConfig.dart';

import '../models/BannerModel.dart';
import '../models/ProductModel.dart';
import '../utils/Utils.dart';
import '../widget/empty_list.dart';
import '../widget/product_item_ui.dart';
import '../widget/shimmer_loading_widget.dart';

class TestPage1 extends StatefulWidget {
  int page_num;

  //const TestPage1({Key? key}) : super(key: key, this.page);
  TestPage1(this.page_num);

  @override
  State<TestPage1> createState() => _TestPage1State(this.page_num);
}

List<BannerModel> banners = [];
bool initilized = false;
bool store_initilized = false;
BannerModel horizontal_banner_1 = BannerModel();
BannerModel horizontal_banner_2 = BannerModel();
BannerModel horizontal_banner_3 = BannerModel();
List<ProductModel> _trending_products = [];

class _TestPage1State extends State<TestPage1> {
  int page_num;

  _TestPage1State(this.page_num);

  Future<void> _init_databse() async {
    _trending_products.clear();
    List<ProductModel> _trending_get = await ProductModel.get_trending();
    _trending_get.forEach((element) {
      _trending_products.add(element);
    });
    _trending_products.shuffle();
    _trending_products.shuffle();

    banners = await BannerModel.get();
    int i = 0;
    _gridItems.clear();

    _gridBannersItems.clear();
    _gridBannersItems2.clear();
    banners.forEach((element) {
      i++;

      if (page_num == 1 && i == 1) {
        horizontal_banner_1 = element;
      } else if (page_num == 2 && (i == 18)) {
        horizontal_banner_1 = element;
      } else if (page_num == 3 && (i == 35)) {
        horizontal_banner_1 = element;
      }

/*      if ( (banners.length % (i*page_num)) == 1) {

      }*/

      if (((i > 1) && (i < 10)) && page_num == 1) {
        _gridItems.add(element);
      } else if (((i > 18) && (i < 27)) && page_num == 2) {
        _gridItems.add(element);
      } else if (((i > (18 + 17)) && (i < (27 + 17))) && page_num == 3) {
        _gridItems.add(element);
      }

      if (i == 10 && page_num == 1) {
        horizontal_banner_2 = element;
      } else if ((i) == 27 && page_num == 2) {
        horizontal_banner_2 = element;
      } else if ((i) == (27 + 17) && page_num == 3) {
        horizontal_banner_2 = element;
      }

      if (((i > 10) && (i < 13)) && page_num == 1) {
        _gridBannersItems.add(element);
      } else if ((((i) > 27) && ((i) < 30)) && page_num == 2) {
        _gridBannersItems.add(element);
      } else if ((((i) > (27 + 17)) && ((i) < (30 + 17))) && page_num == 3) {
        _gridBannersItems.add(element);
      }

      if (((i > 12) && (i < 17)) && page_num == 1) {
        _gridBannersItems2.add(element);
      } else if (((i > 29) && (i < 34)) && page_num == 2) {
        _gridBannersItems2.add(element);
      } else if (((i > (29 + 17)) && (i < (34 + 17))) && page_num == 3) {
        _gridBannersItems2.add(element);
      }

      if (i == 17 && page_num == 1) {
        horizontal_banner_3 = element;
      } else if (i == 34 && page_num == 2) {
        horizontal_banner_3 = element;
      } else if (i == (34 + 17) && page_num == 3) {
        horizontal_banner_3 = element;
      }
    });

    initilized = true;
    setState(() {});
    return null;
  }

  @override
  void initState() {
    initilized = false;
    _init_databse();
  }

  @override
  void dipose() {
    store_initilized = false;
  }

  List<String> _items = [];
  List<BannerModel> _gridItems = [];
  List<BannerModel> _gridBannersItems = [];
  List<BannerModel> _gridBannersItems2 = [];
  int i = 0;

  Future<Null> _onRefresh() async {
    initilized = false;
    await _init_databse();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    /*_gridBannersItems.clear();
    _gridBannersItems2.clear();


    _gridBannersItems2.add(new ProductModel());
    _gridBannersItems2.add(new ProductModel());*/

    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      imageUrl:
                          "${AppConfig.BASE_URL}/${horizontal_banner_1.image}",
                      placeholder: (context, url) => ShimmerLoadingWidget(
                        height: 200,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                },
                childCount: 1, // 1000 list items
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 2,
                  mainAxisExtent: 100),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return singleGridItem(_gridItems[index]);
                },
                childCount: _gridItems.length,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl:
                          "${AppConfig.BASE_URL}/${horizontal_banner_2.image}",
                      placeholder: (context, url) => ShimmerLoadingWidget(
                          height: 90, width: 90, is_circle: true),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                },
                childCount: 1, // 1000 list items
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 7,
                  childAspectRatio: 2,
                  mainAxisExtent: 240),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return singleGridImageItem(_gridBannersItems[index], index);
                },
                childCount: _gridBannersItems.length,
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                  mainAxisExtent: 110),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return singleGridImageIte2(_gridBannersItems2[index], index);
                },
                childCount: _gridBannersItems2.length,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      height: 220,
                      fit: BoxFit.fill,
                      imageUrl:
                          "${AppConfig.BASE_URL}/${horizontal_banner_3.image}",
                      placeholder: (context, url) => ShimmerLoadingWidget(
                        height: 220,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                },
                childCount: 1, // 1000 list items
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(top: 0, left: 18),
                    child: FxText.b1(
                      "You may also like",
                    ),
                  );
                },
                childCount: 1, // 1000 list items
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                  mainAxisExtent: 300),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ProductItemUi(
                      index, _trending_products[index], context);
                },
                childCount: _trending_products.length,
              ),
            ),
          ],
        ));
  }

  Widget singleGridImageIte3(ProductModel productModel, int index) {
    return InkWell(
      onTap: ()=>{open_product_listting()},
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 10,
          left: (index.isOdd) ? 0 : 15,
          right: (index.isOdd) ? 15 : 0,
        ),
        child: Column(
          children: [
            Image.asset(
              "assets/project/${productModel.thumbnail}",
              height: 210,
              fit: BoxFit.cover,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                  child: Text(
                    productModel.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                        fontSize: 16),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),
                  child: Icon(
                    Icons.verified_rounded,
                    color: Colors.grey.shade800,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget singleGridImageIte2(BannerModel productModel, int index) {
    return InkWell(
      onTap: ()=>{open_product_listting()},
      child: Container(
        color: (page_num == 1)
            ? Color.fromARGB(255, 188, 223, 204)
            : (page_num == 2)
                ? Color.fromARGB(255, 219, 184, 158)
                : (page_num == 3)
                    ? Color.fromARGB(255, 150, 204, 239)
                    : Color.fromARGB(255, 188, 223, 204),
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(
          top: 10,
          left: (index.isOdd) ? 0 : 15,
          right: (index.isOdd) ? 15 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  productModel.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(productModel.sub_title),
              ],
            ),
            CachedNetworkImage(
              height: 100,
              fit: BoxFit.cover,
              imageUrl: "${AppConfig.BASE_URL}/${productModel.image}",
              placeholder: (context, url) =>
                  ShimmerLoadingWidget(height: 100, width: 100, is_circle: true),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )
          ],
        ),
      ),
    );
  }

  Widget singleGridImageItem(BannerModel bannerModel, int index) {
    return InkWell(
      onTap: ()=>{open_product_listting()},
      child: Container(
        height: 240,
        padding: EdgeInsets.only(
          top: 5,
          left: (index.isOdd) ? 0 : 15,
          right: (index.isOdd) ? 15 : 0,
        ),
        alignment: Alignment.center,
        child: CachedNetworkImage(

          width: ((MediaQuery.of(context).size.width/2)-15),
          fit: BoxFit.fill,
          imageUrl: "${AppConfig.BASE_URL}/${bannerModel.image}",
          placeholder: (context, url) => ShimmerLoadingWidget(
            height: 210,
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  Widget singleGridItem(BannerModel data) {
    return InkWell(
      onTap: ()=>{open_product_listting()},
      child: Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child: Column(
          children: [
            CachedNetworkImage(
              height: 70,
              imageUrl: "${AppConfig.BASE_URL}/${data.image}",
              placeholder: (context, url) => ShimmerLoadingWidget(
                  height: 100, width: 100, is_circle: true, padding: 0),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Text(
              data.name,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
  void open_product_listting(){
    Utils.navigate_to(AppConfig.ProductListting, context);
  }
}
