import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ict4farmers/models/CategoryModel.dart';
import 'package:ict4farmers/models/UserModel.dart';
import 'package:ict4farmers/theme/app_theme.dart';
import 'package:ict4farmers/utils/AppConfig.dart';
import 'package:ict4farmers/widget/loading_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/FormItemModel.dart';
import '../../models/LocationModel.dart';
import '../../models/ProductModel.dart';
import '../../theme/app_notifier.dart';
import '../../utils/Utils.dart';
import '../../widget/shimmer_list_loading_widget.dart';

class ProductAddForm extends StatefulWidget {
  @override
  State<ProductAddForm> createState() => ProductAddFormState();
}

List<FormItemModel> pages = [];
bool initilized = false;
bool store_initilized = false;
FormItemModel activeField = new FormItemModel();
late CustomTheme customTheme;

class ProductAddFormState extends State<ProductAddForm> {
  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    _onRefresh();
  }

  @override
  void dipose() {
    pageController.dispose();
  }

  List<FormItemModel> form_data = [];
  List<FormItemModel> saved_form_data = [];

  List<CategoryModel> sub_categories = [];
  List<CategoryModel> categories = [];
  List<LocationModel> locations = [];

  Future<Null> _onRefresh() async {
    pages.clear();

    locations = await LocationModel.get_all();
    (await CategoryModel.get_all()).forEach((element) {
      if (element.parent > 0) {
        sub_categories.add(element);
      } else {
        categories.add(element);
      }
    });

    saved_form_data = await FormItemModel.get_all();

    FormItemModel category = new FormItemModel();
    category.id = 1000;
    FormItemModel sub_category = new FormItemModel();
    sub_category.id = 2000;
    FormItemModel district = new FormItemModel();
    district.id = 3000;
    FormItemModel sub_county = new FormItemModel();
    sub_county.id = 4000;

    FormItemModel images_field = new FormItemModel();

    images_field.id = 5000;
    images_field.type = AppConfig.form_field_image_picker;

    FormItemModel prodcut_title = new FormItemModel();
    prodcut_title.id = 6000;
    prodcut_title.type = AppConfig.form_field_text;

    FormItemModel prodcut_price = new FormItemModel();
    prodcut_price.id = 7000;
    prodcut_price.type = AppConfig.form_field_number;

    FormItemModel prodcut_description = new FormItemModel();
    prodcut_description.id = 8000;
    prodcut_description.type = AppConfig.form_field_text;

    saved_form_data.forEach((element) {
      if (element.id == 1000) {
        category = element;
      } else if (element.id == 2000) {
        sub_category = element;
      } else if (element.id == 3000) {
        district = element;
      } else if (element.id == 4000) {
        sub_county = element;
      } else if (element.id == 5000) {
        images_field = element;
        images_field.type = AppConfig.form_field_image_picker;
      } else if (element.id == 6000) {
        prodcut_title = element;
        prodcut_title.type = AppConfig.form_field_text;
      } else if (element.id == 7000) {
        prodcut_price = element;
        prodcut_price.type = AppConfig.form_field_text;
      } else if (element.id == 8000) {
        prodcut_description = element;
        prodcut_description.type = AppConfig.form_field_text;
      }
    });

    if (category.value.isEmpty) {
      category.id = 1000;
      category.category_id = 0;
      category.name = "Category";
      category.description = "Please select your Advert's category.";
      category.type = AppConfig.form_field_select;
      category.units = "";
      category.value = "";
      category.is_required = true;
    }

    if (prodcut_price.value.isEmpty) {
      prodcut_price.category_id = 0;
      prodcut_price.name = "Product price";
      prodcut_price.is_required = true;
      prodcut_price.description = "What is the price of this item?";
    }

    if (prodcut_description.value.isEmpty) {
      prodcut_description.category_id = 0;
      prodcut_description.name = "Product description";
      prodcut_description.is_required = true;
      prodcut_description.type = AppConfig.form_field_text;
      prodcut_description.description =
          "Please provide a clear and complete description about this item";
    }

    if (prodcut_title.value.isEmpty) {
      prodcut_title.category_id = 0;
      prodcut_title.name = "Advert's title";
      prodcut_title.description = "Enter a simple precise title for this Ad";
      prodcut_title.type = AppConfig.form_field_select;
      prodcut_title.units = "";
      prodcut_title.value = "";
      prodcut_title.is_required = true;
    }

    if (district.value.isEmpty) {
      district.category_id = 0;
      district.name = "District";
      district.description = "Where is this advert located?";
      district.type = AppConfig.form_field_select;
      district.units = "";
      district.value = "";
      district.is_required = true;
    }

    if (sub_county.value.isEmpty) {
      sub_county.category_id = 0;
      sub_county.name = "Sub county";
      sub_county.description = "Where is this advert located?";
      sub_county.type = AppConfig.form_field_select;
      sub_county.units = "";
      sub_county.value = "";
      sub_county.is_required = true;
    }

    if (sub_category.value.isEmpty) {
      sub_category.category_id = 0;
      sub_category.name = "Sub Category";
      sub_category.description = "Please select sub category.";
      sub_category.type = AppConfig.form_field_select;
      sub_category.units = "";
      sub_category.value = "";
      sub_category.is_required = true;
    }

    if (images_field.value.isEmpty) {
      images_field.category_id = 0;
      images_field.name = "Advert images";
      images_field.description =
          "Please take and select advert's pictures. (15 MAX)";
      images_field.type = AppConfig.form_field_image_picker;
      images_field.units = "";
      images_field.value = "";
      images_field.is_required = true;
    }

    images_field.type = AppConfig.form_field_image_picker;

    pages.add(category);
    pages.add(sub_category);
    pages.add(district);
    pages.add(sub_county);
    pages.add(prodcut_title);
    pages.add(prodcut_price);
    pages.add(prodcut_description);
    pages.add(images_field);

    form_data.add(category);
    form_data.add(sub_category);
    form_data.add(district);
    form_data.add(sub_county);
    form_data.add(images_field);

    form_data.add(prodcut_price);
    form_data.add(prodcut_description);

    form_data.add(prodcut_title);

    if (saved_form_data.length > 2) {
      await FormItemModel.save_to_local_db(form_data, true);
    }

    _onPageChanged(0);
    setState(() {});

    return null;
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeField.name,
                          style: TextStyle(
                              color: CustomTheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        padding: FxSpacing.x(0), child: Icon(Icons.close)),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: PageView(
                    pageSnapping: true,
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) => {_onPageChanged(index)},
                    children: _buildHouseList(pageController,
                        categories: categories,
                        sub_categories: sub_categories,
                        locations: locations),
                  )),
            ));
      },
    );
  }

  _onPageChanged(int index) {
    activeField = pages[index];
    setState(() {});
  }
}

List<Widget> _buildHouseList(
  PageController pageController, {
  required List<CategoryModel> sub_categories,
  required List<CategoryModel> categories,
  required List<LocationModel> locations,
}) {
  List<Widget> list = [];

  int index = 0;
  pages.forEach((element) {
    list.add(_SinglePage(element, pageController, customTheme, pages.length,
        index, categories, sub_categories, locations));
    index++;
  });

  return list;
}

class _SinglePage extends StatefulWidget {
  final FormItemModel _item;
  final PageController pageController;
  CustomTheme customTheme;
  int length;
  int index;

  List<CategoryModel> sub_categories;
  List<CategoryModel> categories;
  List<LocationModel> locations;

  _SinglePage(this._item, this.pageController, this.customTheme, this.length,
      this.index, this.categories, this.sub_categories, this.locations);

  @override
  State<_SinglePage> createState() =>
      _SinglePageState(this.categories, this.sub_categories, this.locations);
}

class _SinglePageState extends State<_SinglePage> {
  FormItemModel item = new FormItemModel();

  List<CategoryModel> sub_categories;
  List<CategoryModel> categories;
  List<LocationModel> locations;
  List<String> temp_images = [];

  _SinglePageState(this.categories, this.sub_categories, this.locations);

  late FocusNode myFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_item();
  }

  bool is_read_only = false;
  bool is_select = false;
  bool is_image_picker = false;
  bool is_loading = true;
  bool is_uploading = false;
  bool is_last_page = false;

  @override
  Widget build(BuildContext context) {
    myFocusNode = FocusNode();
    //myFocusNode.requestFocus();
    return FxContainer(
      color: Colors.white,
      borderRadiusAll: 0,
      paddingAll: 0,
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxProgressBar(
                    width: MediaQuery.of(context).size.width,
                    activeColor: CustomTheme.primary,
                    radius: 0,
                    inactiveColor: CustomTheme.primary.withAlpha(40),
                    progress: (widget.index + 1) / widget.length,
                    height: 5,
                  ),
                  activeField.description.isEmpty
                      ? SizedBox()
                      : Container(
                          padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                              bottom: (is_select || is_image_picker) ? 20 : 0),
                          child: FxText(
                            activeField.description,
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 16),
                          ),
                        ),
                  error_message.isEmpty
                      ? SizedBox()
                      : FxContainer(
                          width: double.infinity,
                          color: Colors.red.shade100,
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 10),
                          child: FxText(
                            error_message,
                            style: TextStyle(
                                color: Colors.red.shade800, fontSize: 16),
                          ),
                        ),
                  ((!is_loading) && (!is_select) && (!is_image_picker))
                      ? FxContainer(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormBuilderTextField(
                                  name: "name",
                                  initialValue: item.value,
                                  focusNode: myFocusNode,
                                  keyboardType: (this.item.type ==
                                          AppConfig.form_field_text)
                                      ? TextInputType.name
                                      : (this.item.type ==
                                              AppConfig.form_field_number)
                                          ? TextInputType.number
                                          : TextInputType.name,
                                  validator: (item.is_required)
                                      ? FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                            context,
                                            errorText:
                                                "${item.name} is required.",
                                          ),
                                        ])
                                      : FormBuilderValidators.compose([]),
                                  decoration:
                                      widget.customTheme.input_decoration(
                                    labelText: item.name,
                                  )),
                            ],
                          ))
                      : SizedBox()
                ],
              ),
            ),
            is_loading
                ? ShimmerListLoadingWidget()
                : is_select
                    ? Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return single_item(index,
                                      item.options[index].toString(), context);
                                },
                                childCount: item.options.length,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
            ((!is_loading) && (!is_select) && (is_image_picker))
                ? Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                            childAspectRatio: 1,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return single_image_picker(index,
                                  item.options[index].toString(), context);
                            },
                            childCount: item.options.length,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            Container(
                padding: EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        right: 20,
                      ),
                      width: double.infinity,
                      child: !is_uploading
                          ? Text(
                              "STEP ${widget.index + 1}/${(widget.length)}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.end,
                            )
                          : Text(
                              "Uploading...",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.end,
                            ),
                    ),
                    Container(
                        child: is_uploading
                            ? LoadingWidget()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width /
                                        2.3),
                                    child: FxButton.outlined(
                                        borderColor: CustomTheme.primary,
                                        onPressed: () =>
                                            {previous_page(context)},
                                        child: Text(
                                          is_last_page ? "EDIT" : "PREVIOUS",
                                          style: TextStyle(
                                              color: CustomTheme.primary),
                                        )),
                                  ),
                                  Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                              2.3),
                                      child: FxButton.block(
                                          onPressed: () =>
                                              {next_page(context, item)},
                                          child: Text(is_last_page
                                              ? "SUBMIT"
                                              : "NEXT"))),
                                ],
                              )),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormBuilderState>();
  String error_message = "";

  next_page(context, FormItemModel item) async {
    error_message = "";
    if (is_loading) {
      return;
    }

    if (is_select) {
      if (item.is_required && item.value.isEmpty) {
        error_message = "You must select ${item.name}";
        setState(() {});
        return;
      }
    } else {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      if (_formKey != null) {
        if (_formKey.currentState != null) {
          if (_formKey.currentState?.fields['name']?.value != null) {
            item.value = _formKey.currentState?.fields['name']?.value;
          }
        }
      }
    }

    if (item.value.isEmpty) {
      if (_formKey.currentState?.fields['name'] != null) {
        if (_formKey.currentState?.fields['name']?.value != null) {
          item.value = _formKey.currentState?.fields['name']?.value;
        }
      }
    }

    if (item.is_required && item.value.isEmpty && !is_image_picker) {
      error_message = "You must select ${item.name}";
      setState(() {});
      return;
    }

    if (is_image_picker && item.is_required && (item.options.length < 2)) {
      error_message = "You must select ${item.name}";
      setState(() {});
      return;
    } else {}

    await FormItemModel.save_iteem_to_local_db(item);

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (is_last_page) {
      do_upload_process();
    } else {
      widget.pageController
          .nextPage(duration: Duration(microseconds: 1), curve: Curves.ease);
    }
  }

  previous_page(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    widget.pageController
        .previousPage(duration: Duration(microseconds: 1), curve: Curves.ease);
  }

  void get_item() async {
    if ((widget.index + 1) == (widget.length)) {
      is_last_page = true;
    } else {
      is_last_page = false;
    }
    setState(() {});
    is_loading = true;
    error_message = "";
    item = await FormItemModel.get_item(widget._item.id);

    if (item.id < 1) {
      item = widget._item;
    }

    if (item.id == 1000) {
      item.options.clear();
      categories.forEach((element) {
        item.options.add(element.name);
      });
      item.options.sort();
    } else if (item.id == 2000) {
      item.options.clear();

      ///kjjs
      FormItemModel main_category = await FormItemModel.get_item(1000);
      int main_cat_id = 0;
      categories.forEach((element) {
        if (element.name == main_category.value) {
          main_cat_id = element.id;
        }
      });

      sub_categories.forEach((element) {
        if (main_cat_id > 0) {
          if (element.parent == main_cat_id) {
            item.options.add(element.name);
          }
        }
      });
      item.options.sort();
      item.options.add("Other");
    } else if (item.id == 3000) {
      item.options.clear();

      ///kjjs
      locations.forEach((element) {
        if (element.parent_id < 1) {
          item.options.add(element.name);
        }
      });
      item.options.sort();
    } else if (item.id == 4000) {
      item.options.clear();
      FormItemModel main_loc = await FormItemModel.get_item(3000);
      int main_loc_id = 0;
      locations.forEach((element) {
        if (element.name == main_loc.value) {
          main_loc_id = element.id;
        }
      });

      locations.forEach((element) {
        if (main_loc_id > 0) {
          if (element.parent_id == main_loc_id) {
            item.options.add(element.name);
          }
        }
      });
      item.options.sort();
      item.options.add("Other");
    }

    if ((item.type == AppConfig.form_field_select) && (!item.options.isEmpty)) {
      is_read_only = true;
      is_select = true;
    } else {
      is_read_only = false;
      is_select = false;
    }

    if ((item.type == AppConfig.form_field_image_picker)) {
      if (item.options != null && !item.options.isEmpty) {
        temp_images.clear();

        item.options.forEach((value) {
          if (value != AppConfig.form_field_image_picker) {
            temp_images.add(value);
          }
        });

        item.options.clear();
        item.options.add(AppConfig.form_field_image_picker);

        temp_images.forEach((__element) {
          if (__element != AppConfig.form_field_image_picker) {
            item.options.add(__element);
          }
        });
      } else {
        item.options.add(AppConfig.form_field_image_picker);
      }

      is_image_picker = true;
    }

    is_loading = false;
    setState(() {});
  }

  void _on_select_optpion(String value) async {
    item.value = value;
    setState(() {});
  }

  bool is_selected_value = false;

  Widget single_image_picker(int index, String _item, BuildContext context) {
    return (_item == AppConfig.form_field_image_picker)
        ? InkWell(
            onTap: () => {do_pick_image()},
            child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: CustomTheme.primary,
                      width: 1,
                      style: BorderStyle.solid),
                  color: CustomTheme.primary.withAlpha(25),
                ),
                padding: EdgeInsets.all(0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 35, color: CustomTheme.primary),
                      Center(child: Text("add photo")),
                    ])))
        : Stack(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: CustomTheme.primary,
                      width: 1,
                      style: BorderStyle.solid),
                  color: CustomTheme.primary.withAlpha(25),
                ),
                padding: EdgeInsets.all(0),
                child: Image.file(
                  File(_item),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                  child: InkWell(
                    onTap: () => {romove_image_at(index)},
                    child: Container(
                      child: FxContainer(
                        width: 35,
                        alignment: Alignment.center,
                        borderRadiusAll: 17,
                        height: 35,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        color: Colors.red.shade700,
                        paddingAll: 0,
                      ),
                    ),
                  ),
                  right: 0),
            ],
          );
  }

  Widget single_item(int index, String _item, BuildContext context) {
    if (item.value == _item) {
      is_selected_value = true;
    } else {
      is_selected_value = false;
    }

    return InkWell(
      onTap: () => {_on_select_optpion(_item.toString())},
      child: FxContainer(
        borderRadiusAll: 0,
        color: is_selected_value ? CustomTheme.primary : Colors.white,
        padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
        child: Row(
          children: [
            Container(
              child: FxContainer(
                width: 35,
                alignment: Alignment.center,
                borderRadiusAll: 17,
                height: 35,
                child: is_selected_value
                    ? Icon(
                        Icons.check,
                        color: CustomTheme.primary,
                      )
                    : FxText(
                        "${index + 1}",
                        color: is_selected_value
                            ? CustomTheme.primary
                            : Colors.white,
                      ),
                color: !is_selected_value ? CustomTheme.primary : Colors.white,
                paddingAll: 0,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            FxContainer(
                borderRadiusAll: 0,
                paddingAll: 0,
                color: is_selected_value ? CustomTheme.primary : Colors.white,
                child: FxText(
                  "${_item}",
                  fontSize: 18,
                  color:
                      !is_selected_value ? Colors.grey.shade700 : Colors.white,
                )),
          ],
        ),
      ),
    );
  }

  void romove_image_at(int image_position) {
    item.options.removeAt((image_position));
    setState(() {});
  }

  do_pick_image() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    images?.forEach((element) {
      if (element.path == null) {
        return;
      }
      if (item.options.length < 16) {
        item.options.add(element.path);
      }
      // /data/user/0/eighttechnologies.net.ict4farmers/cache/image_picker3734385312125071389.jpg
    });
    setState(() {});
  }

  List<FormItemModel> form_data_to_upload = [];

  void do_upload_process() async {
    Map<String, dynamic> form_data_map = {};
    form_data_to_upload.clear();
    form_data_to_upload = await FormItemModel.get_all();

    UserModel userModel = await Utils.get_logged_in();
    if (userModel.id < 1) {
      Utils.showSnackBar(
          "Login before  you proceed.", context, CustomTheme.onPrimary);
      return;
    }

    bool first_found = false;
    form_data_map['user_id'] = userModel.id;

    for (int _counter = 0; _counter < form_data_to_upload.length; _counter++) {
      FormItemModel element = form_data_to_upload[_counter];
      if (element.type != AppConfig.form_field_image_picker) {
        form_data_map[element.name] = element.value;
      } else {
        if (element.options != null && !element.options.isEmpty) {
          for (int __counter = 0;
              __counter < form_data_to_upload.length;
              __counter++) {
            if (first_found) {
              try {
                var img = await MultipartFile.fromFile(
                    element.options[__counter],
                    filename: 'image_${__counter}');
                if (img != null) {
                  form_data_map['image_${__counter}'] =
                      await MultipartFile.fromFile(element.options[__counter],
                          filename: 'image_${__counter}');
                } else {}
              } catch (e) {}
            }
            first_found = true;
          }
          ;
        }
      }
    }

    var formData = FormData.fromMap(form_data_map);
    var dio = Dio();
    setState(() {
      is_uploading = true;
    });
    var response =
        await dio.post('${AppConfig.BASE_URL}/api/products', data: formData);

    await ProductModel.get_user_products(userModel.id);
    setState(() {
      is_uploading = false;
    });

    if (response == null) {
      Utils.showSnackBar("Failed to upload product. Please try again.", context,
          Colors.red.shade700);
      return;
    }

    if (response.data['status'] == null) {
      Utils.showSnackBar("Failed to upload product. Please try again.", context,
          Colors.red.shade700);
      return;
    }

    if (response.data['status'].toString() != '1') {
      Utils.showSnackBar(
          response.data['status'].toString(), context, Colors.red.shade700);
      return;
    }
    await ProductModel.get_user_products(userModel.id);
    //await FormItemModel.delete_all();
    Utils.showSnackBar(
        response.data['message'].toString(), context, CustomTheme.onPrimary);

    Navigator.pop(context, {"task": 'success'});
  }
}
