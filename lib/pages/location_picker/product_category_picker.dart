import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/models/CategoryModel.dart';
import 'package:ict4farmers/pages/location_picker/product_sub_category_picker.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../theme/app_notifier.dart';
import '../../widget/shimmer_list_loading_widget.dart';

class ProductCategoryPicker extends StatefulWidget {
  @override
  State<ProductCategoryPicker> createState() => PproducCcategorPpicker();
}

late CustomTheme customTheme;
String title = "Pick category";
bool is_loading = false;

class PproducCcategorPpicker extends State<ProductCategoryPicker> {
  PproducCcategorPpicker();

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    _do_refresh();
    AppTheme.init();
  }

  List<CategoryModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});
    List<CategoryModel> _items = await CategoryModel.get_all();
    items.clear();
    _items.forEach((element) {
      if (element.parent < 1) {
        items.add(element);
      }
    });

    items.sort((a, b) => a.name.compareTo(b.name));
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
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: .5,
              title: Text(
                title,
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: SafeArea(
              child: is_loading
                  ? ShimmerListLoadingWidget()
                  : RefreshIndicator(
                onRefresh: _do_refresh,
                color: CustomTheme.primary,
                backgroundColor: Colors.white,
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return SingleProduct(items[index]);
                        },
                        childCount: items.length, // 1000 list items
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<Null> _do_refresh() async {
    return await _onRefresh(context);
  }

  SingleProduct(CategoryModel item) {
    return ListTile(
      dense: true,
      title: FxText.h3(item.name, fontWeight: 400, fontSize: 20),
      onTap: () {
        pick_sub(item);
        /* Navigator.pop(context,
            {"category_id": item.id.toString(), "category_text": item.name});*/
      },
    );
  }

  Future<void> pick_sub(CategoryModel item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductSubCategoryPicker({
            'parent_id': item.id.toString(),
          })),
    );

    if (result != null) {
      if ((result['sub_id'] != null) && (result['sub_name'] != null)) {
        Navigator.pop(context, {
          "category_id": result['sub_id'],
          "category_text": item.name + ", " + result['sub_name'].toString()
        });
      }
    }
  }
}
