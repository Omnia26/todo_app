// ignore_for_file: use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_is_empty, import_of_legacy_library_into_null_safe, unused_import

import 'package:conditional_builder/conditional_builder.dart';
import 'package:api_projects/shared/components/components.dart';
import 'package:api_projects/todo_app/controllers/cubitt.dart';
import 'package:api_projects/todo_app/controllers/statuss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class newTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, States>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newtasks;

        return tasksBuilder(tasks: tasks,);
      },
    );
  }
}
 