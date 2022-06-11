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
import 'order_hospital_picker.dart';

class OrderLocationSub extends StatefulWidget {
  OrderLocationSub();

  @override
  State<OrderLocationSub> createState() => OorderLocationSub();
}

late CustomTheme customTheme;
String title = "Dooro magaalada";
bool is_loading = false;

class OorderLocationSub extends State<OrderLocationSub> {
  OorderLocationSub();

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    _do_refresh();
    AppTheme.init();
  }

  List<LocationModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});
    items = await LocationModel.get_all();
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
          automaticallyImplyLeading: false,
          // remove back button in appbar.
          backgroundColor: CustomTheme.primary,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: CustomTheme.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark, // For iOS (dark icons)
          ),
          elevation: .5,
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
                title,
                style: TextStyle(color: Colors.white),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderHospitalPicker(item.id)),
        );

        //Navigator.pop(context, {"location_sub_id": item.id.toString(), "location_sub_name": item.name});
      },
    );
  }
}
