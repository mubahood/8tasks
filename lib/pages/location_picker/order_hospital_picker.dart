import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:ict4farmers/models/HospitalModel.dart';
import 'package:ict4farmers/pages/location_picker/order_location_sub.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../models/LocationModel.dart';
import '../../theme/app_notifier.dart';
import '../../widget/shimmer_list_loading_widget.dart';
import 'order_services_results.dart';

class OrderHospitalPicker extends StatefulWidget {
  int location_id;

  OrderHospitalPicker(this.location_id);

  @override
  State<OrderHospitalPicker> createState() => OrderHospitalPickerState();
}

late CustomTheme customTheme;
String title = "Dooro Isbitaalka";
bool is_loading = false;

class OrderHospitalPickerState extends State<OrderHospitalPicker> {
  final PageController pageController = PageController(initialPage: 0);
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    AppTheme.init();
    _do_refresh();
  }

  @override
  void dipose() {
    pageController.dispose();
  }

  List<HospitalModel> items = [];

  Future<Null> _onRefresh(BuildContext _context) async {
    is_loading = true;
    setState(() {});
    List<HospitalModel> _items =
        await HospitalModel.get_items(params: {}, clear_previous: false);
    items.clear();
    _items.forEach((element) {
      if (element.location_id.toString() == widget.location_id.toString()) {
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

  SingleProduct(HospitalModel item) {
    return ListTile(
      dense: true,
      title: FxText.h3(item.name, fontWeight: 400, fontSize: 20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderServicesResults(item.id)),
        );

        //pick_location(item);
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
