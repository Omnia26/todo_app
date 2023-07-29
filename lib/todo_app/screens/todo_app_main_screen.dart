// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, argument_type_not_assignable_to_error_handler, avoid_print, unnecessary_string_interpolations, import_of_legacy_library_into_null_safe, non_constant_identifier_names, avoid_types_as_parameter_names, prefer_is_empty, unused_import, use_key_in_widget_constructors, must_be_immutable, file_names
import 'package:conditional_builder/conditional_builder.dart';
import 'package:api_projects/todo_app/screens/archived_task_screen.dart';
import 'package:api_projects/todo_app/screens/done_task_screen.dart';
import 'package:api_projects/todo_app/screens/new_task_screen.dart';
import 'package:api_projects/shared/components/components.dart';
import 'package:api_projects/todo_app/controllers/cubitt.dart';
import 'package:api_projects/todo_app/controllers/statuss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class TasksTracer extends StatelessWidget {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var descriptioncontroller = TextEditingController();
  var namecontroller = TextEditingController();
  var timecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit()..createDataBase(),
        child: BlocConsumer<AppCubit, States>(listener: (context, state) {
          if (state is AppInsertState) {
            Navigator.pop(context);
          }
        }, builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentindex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentindex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.varshow) {
                  if (formkey.currentState?.validate() == true) {
                    cubit.insertDatabase(
                      time: timecontroller.text,
                      name: namecontroller.text,
                      description: descriptioncontroller.text,
                    );
                  }
                } else {
                  scaffoldkey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(
                            20.0,
                          ),
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: namecontroller,
                                  type: TextInputType.name,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'cannot be empty';
                                    }
                                    return null;
                                  },
                                  prefix: Icons.perm_identity,
                                  label: 'Task Name',
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  controller: timecontroller,
                                  type: TextInputType.text,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'cannot be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) => timecontroller.text =
                                        '${value!.hour}:${value.minute}');
                                  },
                                  prefix: Icons.timer,
                                  label: 'Task Time',
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  controller: descriptioncontroller,
                                  type: TextInputType.text,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'cannot be empty';
                                    }
                                    return null;
                                  },
                                  prefix: Icons.description,
                                  label: 'Task Description',
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changebottomsheetstatus(
                      varrshow2: false,
                      varricon2: Icons.edit,
                    );
                  });
                  cubit.changebottomsheetstatus(
                    varrshow2: true,
                    varricon2: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.varicon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.done,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive,
                  ),
                  label: 'Archive',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentindex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
            ),
          );
        }));
  }
}
