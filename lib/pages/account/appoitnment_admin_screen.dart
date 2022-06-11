import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ict4farmers/models/AppointmentModel.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/UserModel.dart';

class AppointmentAdminScreen extends StatefulWidget {
  AppointmentModel item;

  AppointmentAdminScreen(this.item);

  @override
  _AppointmentAdminScreenState createState() =>
      _AppointmentAdminScreenState(this.item);
}

class _AppointmentAdminScreenState extends State<AppointmentAdminScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  AppointmentModel item;

  _AppointmentAdminScreenState(this.item);

  late CustomTheme customTheme;
  late ThemeData theme;
  String error_message = "";

  bool onLoading = false;

  UserModel logged_in_user = new UserModel();
  List<String> statuses = ['pending', 'canceled', 'accepted', 'completed'];
  List<String> payment_methods = ['paid', 'not paid'];

  Future<void> my_init() async {
    logged_in_user = await Utils.get_logged_in();
    if (logged_in_user.id < 1) {
      Utils.showSnackBar("Login before you proceed.", context, Colors.red);
      Navigator.pop(context);
      return;
    }

    // { mobile money, price: 200, : 2022-05-17 08:00:00.000}

    _formKey.currentState!.patchValue({
      'status': statuses.contains(item.status.toString())
          ? item.status.toString()
          : 'pending',
      'payment_status': payment_methods.contains(item.payment_method.toString())
          ? item.payment_method.toString()
          : 'not paid',
      'appointment_time': item.appointment_time.toString(),
      'price': "USD "+item.price.toString(),
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    my_init();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    // setState(() { onLoading = false;});

    Future<void> submit_form() async {
      error_message = "";

      print("Time to validate shit");
      if (!_formKey.currentState!.validate()) {
        Utils.showSnackBar(
            "Please Check errors in the form and fix them first.",
            context,
            Colors.white,
            background_color: Colors.red);
        return;
      }
      onLoading = true;
      setState(() {});

      Map<String, dynamic> form_data_map = {
        'id': item.id,
        'status': _formKey.currentState?.fields['status']?.value,
        'payment_status':
            _formKey.currentState?.fields['payment_status']?.value,
        'payment_method':
            _formKey.currentState?.fields['payment_method']?.value,
        'price': _formKey.currentState?.fields['price']?.value,
        'appointment_time':
            _formKey.currentState?.fields['appointment_time']?.value,
      };

      String _resp = await Utils.http_post(
          'api/appointments/status-update', form_data_map);
      onLoading = false;
      setState(() {});

      if (_resp == null || _resp.isEmpty) {
        setState(() {
          error_message =
              "Failed to connect to internet. Please check your network and try again.";
        });
        return;
      }
      dynamic resp_obg = jsonDecode(_resp);
      if (resp_obg['status'].toString() != "1") {
        error_message = resp_obg['message'];

        Utils.showSnackBar(error_message, context, Colors.white,
            background_color: CustomTheme.primary);

        setState(() {});
        return;
      }

      AppointmentModel.get_items(params: {}, clear_previous: true);
      Utils.showSnackBar(
          "Appointment updated successfully!.", context, Colors.white,
          background_color: CustomTheme.primary);
      Navigator.pop(context);

      //await Utils.login_user(u);
/*      Navigator.pushNamedAndRemoveUntil(
          context, "/HomesScreen", (r) => false);*/
    }

    /*

    facebook
    twitter
    whatsapp
    instagram

----
cover_photo
avatar
username
password

     */
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: CustomTheme.primary.withAlpha(40))),
      child: Scaffold(
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
                  "Appointment admin",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              InkWell(
                onTap: () {
                  submit_form();
                },
                child: Container(
                    padding: FxSpacing.x(0),
                    child: onLoading ? Text("Sug wax yar...") : Icon(Icons.done)),
              ),
            ],
          ),
        ),
        body: ListView(
          padding: FxSpacing.fromLTRB(20, 0, 20, 0),
          children: [
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FxSpacing.height(15),
                  FormBuilderDropdown(
                    name: 'status',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        context,
                        errorText: "Status is required.",
                      ),
                    ]),
                    decoration: customTheme.input_decoration(
                        labelText: "Appointment Status", icon: Icons.edit),
                    dropdownColor: Colors.white,
                    items: statuses
                        .map((choice) => DropdownMenuItem(
                              value: choice,
                              child: Text('$choice'),
                            ))
                        .toList(),
                  ),
                  FxSpacing.height(10),
                  FormBuilderDropdown(
                    name: 'payment_status',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        context,
                        errorText: "Payment status is required.",
                      ),
                    ]),
                    decoration: customTheme.input_decoration(
                        labelText: "Payment Status", icon: Icons.edit),
                    dropdownColor: Colors.white,
                    items: payment_methods
                        .map((choice) => DropdownMenuItem(
                              value: choice,
                              child: Text('$choice'),
                            ))
                        .toList(),
                  ),
                  FxSpacing.height(10),
                  FormBuilderDropdown(
                    name: 'payment_method',
                    decoration: customTheme.input_decoration(
                        labelText: "Payment method", icon: Icons.edit),
                    dropdownColor: Colors.white,
                    items: <String>[
                      'cash',
                      'mobile money',
                      'bank',
                    ]
                        .map((choice) => DropdownMenuItem(
                              value: choice,
                              child: Text('$choice'),
                            ))
                        .toList(),
                  ),
                  FxSpacing.height(10),
                  FormBuilderTextField(
                    name: "price",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        context,
                        errorText: "Price is required.",
                      ),
                    ]),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: customTheme.input_decoration(
                        labelText: "Amount paid", icon: Icons.person),
                  ),
                  FxSpacing.height(10),
                  FormBuilderDateTimePicker(
                    name: 'appointment_time',
                    inputType: InputType.both,
                    decoration: customTheme.input_decoration(
                      labelText: 'Appointment Time',
                    ),
                    initialTime: TimeOfDay(hour: 8, minute: 0),
                    // initialValue: DateTime.now(),
                    // enabled: true,
                  ),
                  FxSpacing.height(10),
                  onLoading
                      ? Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        )
                      : FxButton.block(
                          borderRadiusAll: 8,
                          onPressed: () {
                            submit_form();
                          },
                          backgroundColor: CustomTheme.primary,
                          child: FxText.l1(
                            "SUBMIT",
                            color: customTheme.cookifyOnPrimary,
                          )),
                  FxSpacing.height(16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _show_bottom_sheet_photo(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () => {do_pick_image("camera")},
                      dense: false,
                      leading: Icon(Icons.camera_alt,
                          color: theme.colorScheme.onBackground),
                      title: FxText.b1("Camera", fontWeight: 600),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () => {do_pick_image("gallery")},
                        leading: Icon(Icons.photo_library_sharp,
                            color: theme.colorScheme.onBackground),
                        title: FxText.b1("Gallery", fontWeight: 600)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  List<XFile>? temp_images = [];

  String new_dp = "";

  do_pick_image(String source) async {
    Navigator.pop(context);

    new_dp = "";

    final ImagePicker _picker = ImagePicker();
    temp_images = [];
    if (source == "camera") {
      final XFile? pic = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 100);
      if (pic != null) {
        temp_images?.add(pic);
      }
    } else {
      final XFile? pic = await _picker.pickImage(source: ImageSource.gallery);
      if (pic != null) {
        temp_images?.add(pic);
      }
    }

    temp_images?.forEach((element) {
      if (element.path == null) {
        return;
      }
      new_dp = element.path;
    });

    setState(() {});
  }
}
