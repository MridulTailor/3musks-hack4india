import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class BackendService {
  static const baseUrl = 'http://10.0.2.2:8000/api';

  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  Future<Response> fetchData(String url) async {
    try {
      final response = await _dio.get(url);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch data');
    }
  }

  Future<Response> startSession() async {
    try {
      final response = await _dio.post('$baseUrl/attendance-session/', data: {
        'action': "on",
      });
      return response;
    } catch (e) {
      throw Exception('Failed to post data, $e');
    }
  }

  Future<Response> endSession(String wifi_id, String session_id) async {
    try {
      final response = await _dio.post('$baseUrl/attendance-session/', data: {
        'action': "off",
        'wifi_id': wifi_id,
        'session_id': session_id,
      });
      return response;
//       {
//     "message": "Session turned off",
//     "active_students": []
// }
    } catch (e) {
      throw Exception('Failed to post data, $e');
    }
  }

  Future<Response?> postAttendance(String wifi_id, String session_id,
      String student_id, String student_name) async {
    var currentdata = DateTime.now();
    try {
      final response = await _dio.post('$baseUrl/attendance-session/', data: {
        'wifi_id': wifi_id,
        'session_id': session_id,
        'date': DateFormat('yyyy-MM-dd').format(currentdata),
        'username': student_name,
        'checkIn': DateFormat('HH:mm:ss').format(currentdata),
      });
      return response;
    } catch (e) {
      log('Failed to post data, $e');
      return null;
    }
  }
}
