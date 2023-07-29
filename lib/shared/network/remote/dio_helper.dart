
// ignore_for_file: camel_case_types

import 'package:dio/dio.dart';

class dioHelper{
  static Dio? dio;
  static init(){
    dio=Dio(
    BaseOptions(
      baseUrl: 'https://student.valuxapps.com/api/',
      receiveDataWhenStatusError: true,
    ),
  );
  }

  static Future<Response> getData({
    required String url,
     Map<String,dynamic>? query,
    String lang='en',
    String? token,
  })async{
    dio?.options.headers= {
        'Content-Type':'application/json',
        'lang':lang,
        'authorization':token,
      };
    return await dio!.get(url,queryParameters: query);//method
  }

  static Future<Response> postData({
    required String url,
    Map<String,dynamic>? query,
    required Map<String,dynamic> data,
    String lang='en',
    String? token,

  }) async 
  {
    dio?.options.headers= {
        'Content-Type':'application/json',
        'lang':lang,
        'authorization':token,
      };
    return dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    Map<String,dynamic>? query,
    required Map<String,dynamic> data,
    String lang='en',
    String? token,

  }) async 
  {
    dio?.options.headers= {
        'lang':lang,
        'authorization':token??'',
        'Content-Type':'application/json',
      };
    return dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}