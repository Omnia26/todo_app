// ignore_for_file: prefer_const_constructors, use_function_type_syntax_for_parameters, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, prefer_is_empty, unused_import, unnecessary_brace_in_string_interps, avoid_types_as_parameter_names, non_constant_identifier_names, sized_box_for_whitespace, sort_child_properties_last, deprecated_member_use

import 'package:conditional_builder/conditional_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:api_projects/todo_app/controllers/cubitt.dart';
import 'package:api_projects/todo_app/controllers/statuss.dart';
import 'package:flutter/material.dart';

Widget defaultButton({
  double? width = double.infinity,
  Color? background = Colors.deepOrange,
  bool isUpperCase = true,
  required dynamic function, ////
  required String text,
  double radius = 0.0,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
          radius,
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController? controller,
  required TextInputType? type,
  Function(String value)? onSubmit,
  dynamic onTap,
  Function(String val)? onChange,
  bool ispassword = false,
  required dynamic validate,

  ///
  required IconData? prefix,
  required String? label,
  IconData? suffix,
  dynamic suffixpressed,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    obscureText: ispassword,
    validator: validate,

    ///
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    onTap: onTap,
    decoration: InputDecoration(
      labelText: label!,
      prefixIcon: Icon(
        prefix,
      ),
      suffixIcon: suffix != null
          ? IconButton(
              icon: Icon(
                suffix,
              ),
              onPressed: suffixpressed,
            )
          : null,
      border: OutlineInputBorder(),
    ),
  );
}

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['age']}'),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['name']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    '${model['phonenum']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).update(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).update(
                  status: 'archive',
                  id: model['id'],
                );
              },
              icon: Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).delete(
          id: model['id'],
        );
      },
    );
Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: tasks.length,
      ),
      condition: tasks.length > 0,
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet please Add New Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
Widget buildArticleItem(article, context) => InkWell(
      onTap: () {
        //navigateTo(context, WebView(article['url']));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    '${article['urlToImage']}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${article['title']}',
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

Widget articleBuilder(list, context, {issearch = false}) => ConditionalBuilder(
      condition: list.length > 0,
      builder: (context) => ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildArticleItem(list[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: 10,
      ),
      fallback: (context) => issearch
          ? Container()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );

void navigateTo(context, Widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Widget),
    );

void navigateAndFinish(context, Widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Widget),
      (Route<dynamic> route) => false,
    );

Widget defaultTextButton({
  required function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(text.toUpperCase()),
    );

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget buildListProduct(model, context, {bool isOldPrice = true}) => Padding(
      ///بعد الاندكس كده هنا هحط الكلاس برودكت مش داتافيرجن2.product لو سطر 20 حطيت
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120.0,
        child: Row(
          children: [
            Stack(alignment: AlignmentDirectional.bottomStart, children: [
              Image(
                image: NetworkImage(
                  model.image,
                ),
                fit: BoxFit.cover,
                width: 120.0,
                height: 120.0,
              ),
              // if (model.discount!=0 && isOldPrice)
              //   Container(
              //     color: Colors.red,
              //     padding: EdgeInsets.symmetric(
              //       horizontal: 5.0,
              //     ),
              //     child: Text(
              //       'DISCOUNT',
              //       style: TextStyle(
              //         fontSize: 8.0,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
            ]),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // if (model.discount != 0 && isOldPrice)
                      //   Text(
                      //     '${model..oldPrice.round()}',
                      //     style: TextStyle(
                      //       fontSize: 10,
                      //       color: Colors.grey,
                      //       decoration: TextDecoration.lineThrough,
                      //     ),
                      //   ),
                      // Spacer(),
                      // IconButton(
                      //   onPressed: () {
                      //     ShopCubit.get(context).changeFavourites(model.id);
                      //   },
                      //   icon: CircleAvatar(
                      //     radius: 15.0,
                      //     backgroundColor:
                      //         ShopCubit.get(context).favourites[model.id]!
                      //             ? Colors.blue
                      //             : Colors.grey,
                      //     child: Icon(
                      //       Icons.favorite_border,
                      //       size: 14.0,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
