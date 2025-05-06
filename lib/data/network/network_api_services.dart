import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:widya/data/app_exceptions.dart';
import 'package:widya/data/network/base_api_services.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:widya/utils/utils.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responsejson;
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responsejson = responseJson(response);
    } on SocketException {
      throw InternetException("NO Internet is available right now");
    }

    return responsejson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responsejson;
    try {
      final response = await http
          .post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 10));
      responsejson = responseJson(response);
    } on SocketException {
      throw InternetException("NO Internet is available right now");
    }

    return responsejson;
  }

  dynamic responseJson(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      case 400:
        throw BadRequestException("Bad Request");
      default:
        throw InternetException("${response.statusCode} : ${response.reasonPhrase}");
    }
  }

  Future<dynamic> getGetApiResponseWithHeader(String url, Map<String, String> headers) async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getPostApiResponseWithHeader(String url, Map<String, String> headers, dynamic data, BuildContext context) async {
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(data),);

     if (response.statusCode == 200 || response.statusCode == 201) {
       return jsonDecode(response.body);
    } else {
      AppLogger.logError('Failed to load data : ${response.body}');
      Utils.showToastification("Gagal", "Kamu telah terdaftar dalam kelas ini", false, context);
    }
  }
  
  @override
  Future getDeleteApiResponse(String url, data) {
    // TODO: implement getDeleteApiResponse
    throw UnimplementedError();
  }
  
  @override
  Future getPutApiResponse(String url, data) {
    // TODO: implement getPutApiResponse
    throw UnimplementedError();
  }
}