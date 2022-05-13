import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../models/LocationModel.dart';
import '../../theme/app_notifier.dart';
import '../../widget/shimmer_list_loading_widget.dart';

class OrderLocationSub extends StatefulWidget {
  Map<String, String> initial_data;

  OrderLocationSub(this.initial_data);

  @override
  State<OrderLocationSub> createState() => OorderLocationSub(this.initial_data);
}

late CustomTheme customTheme;
String title = "Pick an a city";
bool is_loading = false;

class OorderLocationSub extends State<OrderLocationSub> {
  Map<String, String> initial_data;

  OorderLocationSub(this.initial_data);

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    _do_refresh();
  }

  List<LocationModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});
    List<LocationModel> _items = await LocationModel.get_all();
    items.clear();
    _items.forEach((element) {
      if (element.parent_id.toString() == initial_data['parent_id']) {
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

  SingleProduct(LocationModel item) {
    return ListTile(
      dense: true,
      title: FxText.h3(item.name, fontWeight: 400, fontSize: 20),
      onTap: () {
        print("Good to go!");
        //Navigator.pop(context, {"location_sub_id": item.id.toString(), "location_sub_name": item.name});
      },
    );
  }
}
