// ignore_for_file: import_of_legacy_library_into_null_safe, unnecessary_import, avoid_print, non_constant_identifier_names, avoid_types_as_parameter_names, unnecessary_string_interpolations, avoid_function_literals_in_foreach_calls, unused_import, depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:api_projects/todo_app/screens/archived_task_screen.dart';
import 'package:api_projects/todo_app/screens/done_task_screen.dart';
import 'package:api_projects/todo_app/screens/new_task_screen.dart';
import 'package:api_projects/shared/cubit/states.dart';
import 'package:api_projects/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_projects/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    newTaskScreen(),
    doneTaskScreen(),
    archivedTaskScreen(),
  ];
    Database? database;
  List<String> titles = [
    'newTask',
    'doneTask',
    'archivedTask',
  ];
  int currentindex = 0;
  List<Map> tasks = [];
  bool showed = false;
  IconData fibicon = Icons.edit;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeBottomSheetState({
    required bool isshow,
    required IconData icon,
  }) {
    showed = isshow;
    fibicon = icon;
    emit(AppChangeBottomSheetState());
  }

  void changeIndex(int index) {
    currentindex = index;
    emit(AppChangeNavBarState());
  }
  
  void createDatabase() {
    openDatabase(
      'todo.db', //db  name
      version: 1,
      onCreate: (database, version) {
        print("database is created");
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((onError) {
          print('onError${onError.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database);
        print("database is opened");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print("$value  inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFromDataBase(database);
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
      emit(AppUpdateDatabaseState());
    });
  } 
  void delete({
    required int id,
  }) async {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?',[id] ).then((value) {
      getDataFromDataBase(Database);
      emit(AppDeleteDatabaseState());
    });
  }

  void getDataFromDataBase(Database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database?.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    }); 
   }
  bool isdark=false;
  void changeAppMode({bool? fromshared}){
    if(fromshared!=null) {
      isdark=fromshared; 
      emit(NewsAppChangeModeState());
    } else {
      isdark=!isdark;
    CacheHelper.putData(key: 'isdark',value: isdark).then((value) {
      emit(NewsAppChangeModeState());
    });
    }      
  }
}
