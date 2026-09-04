import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/report_model.dart';

class ApiService {
  // Android Emulator ke liye PC localhost
  static const String baseUrl = 'http://172.80.8.139:8000';
  static Future<ReportSummary> getReportSummary() async {
    try {
      final response = await http
          .get(
        Uri.parse('$baseUrl/reports/summary'),
      )
          .timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        jsonDecode(response.body);

        return ReportSummary.fromJson(data);
      }

      throw Exception(
        'Failed to load report: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(
        'Report API connection error: $e',
      );
    }
  }
}