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

class OrderLocationMain extends StatefulWidget {
  @override
  State<OrderLocationMain> createState() => OrderLocationMainState();
}

String title = "Pick a region";
bool is_loading = false;

class OrderLocationMainState extends State<OrderLocationMain> {
  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _do_refresh();
    AppTheme.init();
  }

  @override
  void dipose() {
    pageController.dispose();
  }

  List<LocationModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});
    List<LocationModel> _items = await LocationModel.get_all();
    items.clear();
    _items.forEach((element) {
      if (element.parent_id < 1) {
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
          backgroundColor: CustomTheme.primary,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: CustomTheme.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          elevation: .5,
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
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
        pick_location(item);
      },
    );
  }

  Future<void> pick_location(LocationModel item) async {
    /* final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderLocationSub({
                'parent_id': item.id.toString(),
              })),
    );

   if (result != null) {
      if ((result['location_sub_id'] != null) &&
          (result['location_sub_name'] != null)) {
        Navigator.pop(context, {
          "location_sub_id": result['location_sub_id'],
          "location_sub_name":
              item.name + ", " + result['location_sub_name'].toString()
        });
      }
    }*/
  }
}
