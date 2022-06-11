import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ict4farmers/pages/location_picker/location_main.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/Utils.dart';

import '../../models/UserModel.dart';
import '../../utils/AppConfig.dart';

class AccountRegister extends StatefulWidget {
  dynamic params;

  AccountRegister(this.params);

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
    confirmation_text = widget.params['msg'].toString();
    setState(() {

    });
  }

  String product_id = "";
  String confirmation_text = "";

  @override
  Widget build(BuildContext context) {
    //setState(() { onLoading = false;});

    Future<void> submit_form() async {
      product_id = widget.params['id'].toString();

      if (widget.params == null) {
        if (widget.params['id'] == null) {
          product_id = widget.params['id'].toString();
        }
      }
      error_message = "";

      UserModel logged = await Utils.get_logged_in();
      if (logged.id < 1) {
        await Utils.login_user(new UserModel());
        logged = await Utils.get_logged_in();
      }

      if (logged.id < 1) {
        Utils.showSnackBar("Failed to login.", context, Colors.white);
      }

      if (!_formKey.currentState!.validate()) {
        return;
      }

      onLoading = true;
      setState(() {});
      String _resp = await Utils.http_post('api/appointments', {
        'product_id': product_id,
        'name': _formKey.currentState?.fields['name']?.value,
        'client_id': logged.id.toString(),
        'phone': _formKey.currentState?.fields['phone']?.value,
        'address': _formKey.currentState?.fields['address']?.value,
      });

      onLoading = false;
      setState(() {});

      if (_resp == null || _resp.isEmpty) {
        Utils.showSnackBar(
            'Failed to connect to internet. Please check your network and try again.',
            context,
            CustomTheme.primary);
        return;
      }
      dynamic resp_obg = jsonDecode(_resp);
      if (resp_obg['status'].toString() != '1') {
        Utils.showSnackBar(
            resp_obg['message'].toString(), context, Colors.white,
            background_color: Colors.red);
        return;
      }

      Utils.showSnackBar(resp_obg['message'].toString(), context, Colors.white);

      Utils.navigate_to(AppConfig.PaymentPage, context);
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
                  FxSpacing.height(16),
                  FxText.h3(
                    "Doctor appointment confirmation",
                    color: CustomTheme.primary,
                    fontWeight: 800,
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: FxText(
                      confirmation_text,
                      fontWeight: 600,
                      fontSize: 18,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  FxSpacing.height(32),
                  FormBuilderTextField(
                      name: "name",
                      keyboardType: TextInputType.text,
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
                      textInputAction: TextInputAction.next,
                      decoration: customTheme.input_decoration(
                          labelText: "Magacaaga oo sadexan", icon: Icons.person)),
                  FxSpacing.height(24),
                  FormBuilderTextField(
                      name: "phone",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                          errorText: "Lambarkaaga",
                        ),
                      ]),
                      decoration: customTheme.input_decoration(
                          labelText: "Lambarkaaga", icon: Icons.call)),
                  FxSpacing.height(24),
                  FormBuilderTextField(
                    name: "address",
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        context,
                        errorText: "Xaafada aad dagan tahay..",
                      ),
                      FormBuilderValidators.minLength(
                        context,
                        2,
                        errorText: "Xaafada aad dagan tahay.",
                      ),
                      FormBuilderValidators.maxLength(
                        context,
                        200,
                        errorText: "Xaafada aad dagan tahay too long.",
                      ),
                    ]),
                    decoration: customTheme.input_decoration(
                        labelText: "Xaafada aad dagan tahay",
                        icon: Icons.location_on_rounded),
                  ),
                  FxSpacing.height(10),
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
                            "REQUEST APPOINTMENT",
                            color: customTheme.cookifyOnPrimary,
                            fontSize: 20,
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
}
