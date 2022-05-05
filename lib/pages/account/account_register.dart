import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ict4farmers/pages/location_picker/location_main.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/Utils.dart';
import 'package:ict4farmers/widgets/images.dart';

import '../../models/UserModel.dart';
import '../../utils/AppConfig.dart';

class AccountRegister extends StatefulWidget {
  @override
  _AccountRegisterState createState() => _AccountRegisterState();
}

class _AccountRegisterState extends State<AccountRegister> {
  final _formKey = GlobalKey<FormBuilderState>();

  late CustomTheme customTheme;
  late ThemeData theme;
  String error_message = "";
  bool onLoading = false;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    get_location();
  }

  @override
  Widget build(BuildContext context) {
    //setState(() { onLoading = false;});

    Future<void> submit_form() async {
      error_message = "";
      setState(() {});
      if (!_formKey.currentState!.validate()) {
        return;
      }

      if (_formKey.currentState?.fields['password_2']?.value !=
          _formKey.currentState?.fields['password_1']?.value) {
        error_message = "Passwords don't match.";
        setState(() {});
        return;
      }

      onLoading = true;
      setState(() {});
      String _resp = await Utils.http_post('api/users', {
        'password': _formKey.currentState?.fields['password_1']?.value,
        'name': _formKey.currentState?.fields['name']?.value,
        'email': _formKey.currentState?.fields['email']?.value,
        'sub_county': sub_county,
        'latitude': latitude,
        'longitude': longitude,
      });

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
        setState(() {});
        return;
      }

      UserModel u = UserModel.fromMap(resp_obg['data']);

      if (await Utils.login_user(u)) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/HomesScreen", (r) => false);
      } else {
        error_message =
            "Account created but failed to login. Please try again.";
        setState(() {});
      }
    }

    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: CustomTheme.primary.withAlpha(40))),
      child: Scaffold(
        body: ListView(
          padding: FxSpacing.fromLTRB(24, 80, 24, 0),
          children: [
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    child: Image.asset(
                      Images.logo_1,
                      height: 70,
                    ),
                  ),
                  FxSpacing.height(16),
                  FxText.h3(
                    "Create an Account",
                    color: CustomTheme.primary,
                    fontWeight: 800,
                    textAlign: TextAlign.center,
                  ),
                  FxSpacing.height(32),
                  FormBuilderTextField(
                      name: "name",
                      keyboardType: TextInputType.name,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                          errorText: "Name is required.",
                        ),
                        FormBuilderValidators.minLength(
                          context,
                          2,
                          errorText: "Name too short.",
                        ),
                        FormBuilderValidators.maxLength(
                          context,
                          45,
                          errorText: "Name too long.",
                        ),
                      ]),
                      decoration: customTheme.input_decoration(
                          labelText: "Your Full Name", icon: Icons.person)),
                  FxSpacing.height(24),
                  FormBuilderTextField(
                      name: "email",
                      keyboardType: TextInputType.emailAddress,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                          errorText: "Email address required.",
                        ),
                        FormBuilderValidators.email(
                          context,
                          errorText: "Enter valid email address.",
                        ),
                      ]),
                      decoration: customTheme.input_decoration(
                          labelText: "Email address",
                          icon: Icons.alternate_email)),
                  FxSpacing.height(24),
                  FormBuilderTextField(
                      name: "district",
                      readOnly: true,
                      onTap: () => {pick_location()},
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                          errorText: "Location is required.",
                        ),
                      ]),
                      decoration: customTheme.input_decoration(
                          labelText: "Your location", icon: Icons.place)),
                  FxSpacing.height(24),
                  FormBuilderTextField(
                      name: "gps",
                      textCapitalization: TextCapitalization.sentences,
                      readOnly: true,
                      onTap: () => {get_location()},
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                          errorText: "Location on map (GPS) is needed.",
                        ),
                      ]),
                      decoration: customTheme.input_decoration(
                          labelText: "Location on map (GPS)",
                          icon: Icons.gps_fixed)),
                  FxSpacing.height(24),
                  FormBuilderTextField(
                    name: "password_1",
                    keyboardType: TextInputType.visiblePassword,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        context,
                        errorText: "Password is required.",
                      ),
                      FormBuilderValidators.minLength(
                        context,
                        2,
                        errorText: "Password too short.",
                      ),
                      FormBuilderValidators.maxLength(
                        context,
                        45,
                        errorText: "Password too long.",
                      ),
                    ]),
                    decoration: customTheme.input_decoration(
                        labelText: "Password", icon: Icons.lock_outline),
                  ),
                  FxSpacing.height(24),
                  FormBuilderTextField(
                      name: "password_2",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                          errorText: "Password is required.",
                        ),
                        FormBuilderValidators.minLength(
                          context,
                          2,
                          errorText: "Password too short.",
                        ),
                        FormBuilderValidators.maxLength(
                          context,
                          45,
                          errorText: "Password too long.",
                        ),
                      ]),
                      decoration: customTheme.input_decoration(
                          labelText: "Re-enter Password",
                          icon: Icons.lock_outline)),
                  FxSpacing.height(10),
                  FxButton.text(
                      onPressed: () {
                        Utils.navigate_to(AppConfig.PrivacyPolicy, context);
                      },
                      splashColor: CustomTheme.primary.withAlpha(40),
                      child: FxText.l2(
                          "I have read and agreed with Privacy Policy  of ${AppConfig.AppName}.",
                          textAlign: TextAlign.center,
                          decoration: TextDecoration.underline,
                          color: CustomTheme.primary)),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.red.shade50,
                    ),
                    child: error_message.isEmpty
                        ? SizedBox(
                            height: 0,
                            width: 0,
                          )
                        : Container(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              error_message,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),
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
                            "Create an Account",
                            color: customTheme.cookifyOnPrimary,
                          )),
                  FxSpacing.height(16),
                  FxButton.text(
                      onPressed: () {
                        Utils.navigate_to(AppConfig.AccountLogin, context);
                      },
                      splashColor: CustomTheme.primary.withAlpha(40),
                      child: FxText.l2("I have already an account",
                          fontSize: 14, color: CustomTheme.accent)),
                  FxSpacing.height(16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String district = "";
  String longitude = "";
  String latitude = "";
  String sub_county = "";

  Future<void> get_location() async {
    Position p = await Utils.get_device_location();
    if (p != null) {
      if (p.latitude != null && p.longitude != null) {
        latitude = p.latitude.toString();
        longitude = p.longitude.toString();
        _formKey.currentState!.patchValue({
          'gps': "${longitude},${longitude}",
        });
      }
    }
  }

  Future<void> pick_location() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationMain()),
    );

    if (result != null) {
      if ((result['location_sub_id'] != null) &&
          (result['location_sub_name'] != null)) {
        district = result['location_sub_name'];
        sub_county = result['location_sub_id'];
        _formKey.currentState!.patchValue({
          'district': district,
        });
      }
    }
  }
}
