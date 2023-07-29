// ignore_for_file: unused_import, prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unnecessary_null_comparison, deprecated_member_use, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_projects/shared/components/constants.dart';
import 'package:api_projects/shared/cubit/cubit.dart';
import 'package:api_projects/shared/cubit/states.dart';
import 'package:api_projects/shared/network/local/cache_helper.dart';
import 'package:api_projects/shared/network/remote/dio_helper.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:api_projects/shared/bloc_observer.dart';
import 'todo_app/screens/todo_app_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();// ده عشان ال main معموله async
  Bloc.observer = MyBlocObserver();
  dioHelper.init();
  await CacheHelper.init();
  bool isdark=CacheHelper.getData(key: 'isdark');//
  bool onBoarding=CacheHelper.getData(key: 'onBoarding');//
  token=CacheHelper.getData(key: 'token');//متعرف في الconstant
  //print(token);
  // Widget widget;
  // if(onBoarding!=null) 
  // {
  //   if (token!=null) {
  //     widget=ShopLayout();
  //   }
  //   else{
  //     widget=ShopLogin();
  //   }
  // }else{
  //   widget=OnBoardingScreen();
  // }
  runApp(MyApp(
    isdark:isdark,
    //startWidget:widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isdark;
  //final Widget startWidget;

  MyApp({required this.isdark,});//required this.startWidget
  @override
  Widget build(BuildContext context) {
     return 
    MultiBlocProvider(
      providers:
      [
        // BlocProvider(
        //   create: (context) => NewsCubit()..getbussiness()..getSports()..getscience(),
        // ),
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromshared: isdark,
            ),
        ),
        // BlocProvider(
        //   create: (BuildContext context) => ShopCubit()..getHomeData()..getcategoryData()..getFavouriteData()..getProfileData(),
        //     ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              //primarySwatch: Colors.deepOrange,
              scaffoldBackgroundColor: Colors.white,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.deepOrange,
              ),
              appBarTheme: AppBarTheme(
                //backwardsCompatibility: false,
                titleSpacing: 20.0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                  //statusBarBrightness: Brightness.dark,
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.deepOrange,
                elevation: 20.0,
                backgroundColor: Colors.white,
                unselectedItemColor: Colors.grey,
              ),
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.deepOrange,
              ),
            ),
            darkTheme: ThemeData(
              scaffoldBackgroundColor: HexColor('333739'),
              primarySwatch: Colors.deepOrange,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.deepOrange,
              ),
              appBarTheme: AppBarTheme(
                //backwardsCompatibility: false,
                titleSpacing: 20.0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: HexColor('333739'),
                  statusBarIconBrightness: Brightness.light,
                  //statusBarBrightness: Brightness.light,
                ),
                backgroundColor: HexColor('333739'),
                elevation: 0.0,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.deepOrange,
                unselectedItemColor: Colors.grey,
                elevation: 20.0,
                backgroundColor: HexColor('333739'),
              ),
              textTheme: TextTheme(
                  bodyText1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600, 
                color: Colors.white,
              )),
            ),
            themeMode: ThemeMode.light,//AppCubit.get(context).isdark? ThemeMode.dark:
            home: TasksTracer(),
          );
        },
      ),
    );
  }
}


