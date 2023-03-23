import 'package:dio/dio.dart';

var options = BaseOptions(
  //https://
  baseUrl: 'http://52.78.106.235:5000/',
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds:3),
);
