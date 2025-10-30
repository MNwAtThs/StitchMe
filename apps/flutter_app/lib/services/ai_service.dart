import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

class AIService {
  static const String baseUrl = 'http://localhost:8000'; // Update for production
  
  Future<Map<String, dynamic>?> analyzeWound({
    required XFile imageFile,
    List<Map<String, dynamic>>? lidarData,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/analyze-wound');
      final request = http.MultipartRequest('POST', uri);
      
      // Add image file
      final imageBytes = await imageFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: imageFile.name,
        ),
      );
      
      // Add LiDAR data if available
      if (lidarData != null && lidarData.isNotEmpty) {
        request.fields['lidar_data'] = jsonEncode(lidarData);
      }
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        print('AI Service error: ${response.statusCode} - $responseBody');
        return null;
      }
    } catch (e) {
      print('Error calling AI service: $e');
      return null;
    }
  }
  
  Future<Map<String, dynamic>?> processLiDARData(
    List<Map<String, dynamic>> lidarData,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/process-lidar');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'lidar_data': lidarData}),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('LiDAR processing error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error processing LiDAR data: $e');
      return null;
    }
  }
  
  Future<bool> checkServiceHealth() async {
    try {
      final uri = Uri.parse('$baseUrl/health');
      final response = await http.get(uri);
      return response.statusCode == 200;
    } catch (e) {
      print('AI Service health check failed: $e');
      return false;
    }
  }
}


