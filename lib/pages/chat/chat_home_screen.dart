import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:ict4farmers/widget/shimmer_list_loading_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';


import '../../models/UserModel.dart';
import '../../theme/app_notifier.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../../widget/shimmer_loading_widget.dart';
class ChatHomeScreen extends StatefulWidget {
  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  bool is_logged_in = false;
  bool is_loading = true;
  UserModel logged_in_user = new UserModel();

  @override
  void initState() {
    my_init();
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  Future<void> my_init() async {
    is_loading = true;
    setState(() {});
    logged_in_user = await Utils.get_logged_in();
    if (logged_in_user.id < 1) {
      Utils.showSnackBar("Login before you proceed.", context, Colors.red);
      is_logged_in = false;
      return;
    } else {
      is_logged_in = true;
    }
    setState(() {
      is_loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: .5,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "My Chats",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      my_init();
                    },
                    child: Container(
                        padding: FxSpacing.x(0), child: Icon(Icons.add)),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: is_loading
                  ? ShimmerListLoadingWidget()
                  : RefreshIndicator(
                      onRefresh: my_init,
                      color: CustomTheme.primary,
                      backgroundColor: Colors.white,
                      child: CustomScrollView(
                        slivers: [

                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _showFullImage(String imagePath, String imageTag) {}


  Widget singleOption(
      {IconData? icon, required String title, Widget? navigation}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigation!));
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withAlpha(90),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: FxSpacing.fromLTRB(16, 16, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: theme.colorScheme.onPrimary),
              padding: FxSpacing.all(2),
              child: Icon(
                icon,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ),
            Container(
              margin: FxSpacing.top(8),
              child: FxText.sh2(title, color: theme.colorScheme.onPrimary),
            )
          ],
        ),
      ),
    );
  }
}
