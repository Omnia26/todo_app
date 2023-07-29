// ignore_for_file: non_constant_identifier_names, unnecessary_import, avoid_print, avoid_types_as_parameter_names, unnecessary_string_interpolations, avoid_function_literals_in_foreach_calls, unused_import, import_of_legacy_library_into_null_safe, depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:api_projects/todo_app/screens/archived_task_screen.dart';
import 'package:api_projects/todo_app/screens/done_task_screen.dart';
import 'package:api_projects/todo_app/screens/new_task_screen.dart';
import 'package:api_projects/todo_app/controllers/statuss.dart';
import 'package:api_projects/todo_app/controllers/cubitt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<States> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  Database? database;
  int currentindex = 0;
  IconData varicon = Icons.edit;
  bool varshow = false;
  List<Map> tasks = [];
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];

  List<Widget> screens = [
    newTaskScreen(),
    doneTaskScreen(),
    archivedTaskScreen(),
  ];
  List<String> titles = [
    'newTask',
    'doneTask',
    'archivedTask',
  ];
  void changebottomsheetstatus({
    required bool varrshow2,
    required IconData varricon2,
  }) {
    varshow = varrshow2;
    varicon = varricon2;
    emit(AppChangebottomsheetState());
  }

  void changeIndex(int index) {
    currentindex = index;
    emit(AppChangenavbarState());
  }

  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY ,name Text ,time TEXT,description Text, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database);
        print('opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateState());
    });
  }

  Future insertDatabase({
    required String time,
    required String name,
    required String description,
  }) async {
    await database?.transaction((txn) async {
      txn
          .rawInsert(///
              'INSERT INTO tasks(phonenum,age,name,status) VALUES("$description","$time","$name","new")')
          .then((value) {
        print("$value  inserted successfully");
        emit(AppInsertState());
        getDataFromDataBase(Database);
      }).catchError((error) {
        print('onError${error.toString()}');
      });
      return null;
    });
  }

  void update({
    required String status,
    required int id,
  }) async {
    database?.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDataBase(Database);
      emit(AppUpdateState());
    });
  }

  void delete({
    required int id,
  }) async {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(Database);
      emit(AppDeleteState());
    });
  }

  void getDataFromDataBase(Database) {
    newtasks = [];
    donetasks = [];
    archivedtasks = [];
    emit(AppGetDatabaseLoadingState());
    database?.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newtasks.add(element);
        } else if (element['status'] == 'done') {
          donetasks.add(element);
        } else {
          archivedtasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }
}
