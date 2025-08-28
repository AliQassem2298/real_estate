// // ignore_for_file: avoid_print

// ignore_for_file: avoid_print

import 'dart:convert';
// import 'package:dartz/dartz.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String baseUrlImage = 'http://127.0.0.1:8000';
String baseUrl = 'http://127.0.0.1:8000/api'; //////// windows

// String baseUrlImage = 'http://10.0.2.2:8000';
// String baseUrl = 'http://10.0.2.2:8000/api'; ///// emulator

// String baseUrlImage = 'http://192.168.27.48:8000';
// String baseUrl = 'http://192.168.27.48:8000/api'; ///// mobilde

// String baseUrlImage = 'https://3b01-185-177-125-71.ngrok-free.app';
// String baseUrl = 'https://3b01-185-177-125-71.ngrok-free.app/api'; ///// server

class Api {
  Future<dynamic> get({
    required String url,
    @required String? token,
  }) async {
    Map<String, String> headers = {};
    // print("My token 2 :$userToken");
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    http.Response response = await http.get(Uri.parse(url), headers: headers);

    print('url= $url ,headrs=$headers');
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      print('url= $url ,headrs=$headers');

      print(data);
      return data;
    } else if (response.statusCode == 404) {
      return [];
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'];
      throw message;
    }
  }

  Future<dynamic> post({
    required String url,
    @required dynamic body,
    @required String? token,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    );

    print('url= $url ,body=$body ,headers=$headers');

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'];
      throw message;
      // throw Exception(message);
    }
  }

  Future<dynamic> put(
      {required String url,
      @required dynamic body,
      @required String? token}) async {
    Map<String, String> headers = {};
    headers.addAll({'Content-Type': 'application/x-www-form-urlencoded'});
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    print('url = $url body = $body token = $token ');
    http.Response response =
        await http.put(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      throw Exception(
        'there is a problem with status code ${response.statusCode} with body ${jsonDecode(response.body)}',
      );
    }
  }

  Future<dynamic> delete({
    required String url,
    @required dynamic body,
    String? token,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded', // مهم
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    // أضف _method=DELETE للـ body
    final Map<String, dynamic> bodyWithMethod = {
      if (body != null) ...body,
      '_method': 'DELETE'
    };

    print('Deleting with URL: $url, Body: $bodyWithMethod, Headers: $headers');

    final response = await http.post(
      Uri.parse(url),
      body: bodyWithMethod,
      headers: headers,
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.body.isEmpty || response.body == 'null') {
        return {'success': true, 'message': 'Deleted successfully'};
      }
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return {'message': 'Not found'};
    } else {
      // قد ما يكون فيه JSON
      try {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'حدث خطأ في الحذف';
      } catch (e) {
        throw 'السيرفر أعاد خطأ غير متوقع (ربما صفحة HTML). تحقق من الرابط والسيرفر.';
      }
    }
  }
}
