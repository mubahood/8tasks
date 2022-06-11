import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../models/CategoryModel.dart';
import '../../theme/app_notifier.dart';
import '../../widget/shimmer_list_loading_widget.dart';

class ProductSubCategoryPicker extends StatefulWidget {
  Map<String, String> initial_data;

  ProductSubCategoryPicker(this.initial_data);

  @override
  State<ProductSubCategoryPicker> createState() =>
      PproducSsuCcategorPpicker(this.initial_data);
}

String title = "Pick a sub-category";
bool is_loading = false;

class PproducSsuCcategorPpicker extends State<ProductSubCategoryPicker> {
  Map<String, String> initial_data;

  PproducSsuCcategorPpicker(this.initial_data);

  @override
  void initState() {
    super.initState();
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
      if (element.parent.toString() == initial_data['parent_id']) {
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
        Navigator.pop(context, {
          "sub_id": item.id.toString(),
          "sub_name": item.name
        });
      },
    );
  }
}
