import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import '../utils/constants.dart';
import 'interceptor_class.dart'; // Optional for error message display

class ApiService {
  // Define base URL
  final String baseUrl = AppConstants.baseUrl;

  // Create the client with the interceptor
  final client = InterceptedClient.build(interceptors: [CustomInterceptor(),]);

  // Method to perform GET request
  Future<dynamic> getData(String endpoint) async {
    try {
      // Perform the GET request
      final response = await client.get(Uri.parse('$baseUrl$endpoint')).timeout(Duration(seconds: 10));
      // Handle response based on status code
      if (response.statusCode == 200) {
        // Parse the response body
        final jsonData = jsonDecode(response.body
            .replaceAll('â', '’') // Replace garbled apostrophe
            .replaceAll('â', '“') // Replace garbled quotes
            .replaceAll('â', '”') // Replace garbled quotes
            .replaceAll('â¦', '…'));
        print('Data received: $jsonData');

        return jsonData;
      } else {
        _handleError(response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      // Handle network errors
      print('An error occurred: $e');
      Fluttertoast.showToast(msg: 'Network Error: $e');
      return null;
    }
  }

  Future<dynamic> getData2(String endpoint) async {
    try {
      // Perform the GET request
      final response = await client.get(Uri.parse('$endpoint')).timeout(Duration(seconds: 10));

      // Handle response based on status code
      if (response.statusCode == 200) {
        // Parse the response body
        final jsonData = jsonDecode(response.body
            .replaceAll('â', '’') // Replace garbled apostrophe
            .replaceAll('â', '“') // Replace garbled quotes
            .replaceAll('â', '”') // Replace garbled quotes
            .replaceAll('â¦', '…'));
        print('Data received: $jsonData');

        return jsonData;
      } else {
        _handleError(response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      // Handle network errors
      print('An error occurred: $e');
      Fluttertoast.showToast(msg: 'Network Error: $e');
      return null;
    }
  }

  Future<dynamic> postData(String endpoint, dynamic body) async {
    try {
      // Perform the POST request
      debugPrint('pre URL: ${AppConstants.baseUrl}$endpoint/');
      debugPrint('My Sending Data: $body');

      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}$endpoint/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${{AppConstants.token}}', // Optional
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: 10));

      // Handle response based on status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final jsonData = jsonDecode(response.body
            .replaceAll('â', '’') // Replace garbled apostrophe
            .replaceAll('â', '“') // Replace garbled quotes
            .replaceAll('â', '”') // Replace garbled quotes
            .replaceAll('â¦', '…'));
        print('Data posted successfully: $jsonData');
        return jsonData;
      } else {
        // Handle non-200 responses
        _handleError(response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('An error occurred: $e');
      Fluttertoast.showToast(msg: 'Network Error: $e');
      return null;
    }
  }

  Future<dynamic> postData2(String endpoint, dynamic body) async {
    try {
      // Perform the POST request
      debugPrint('URL: $endpoint');
      debugPrint('SEND DATA: $body');

      final response = await client.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.token}', // Optional
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: 10));

      // Handle response based on status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final jsonData = jsonDecode(response.body);
        print('Data posted successfully: $jsonData');
        return jsonData;
      } else {
        // Handle non-200 responses
        _handleError(response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('An error occurred: $e');
      Fluttertoast.showToast(msg: 'Network Error: $e');
      return null;
    }
  }

  Future<dynamic> putData(String endpoint, dynamic body) async {
    debugPrint('SEND DATA $body');
    try {
      // Perform the POST request
      debugPrint('URL: ${AppConstants.baseUrl}$endpoint');

      final response = await client.put(
        Uri.parse('${AppConstants.baseUrl}$endpoint/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${{AppConstants.token}}', // Optional
        },
        body: jsonEncode(body),
      );

      // Handle response based on status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final jsonData = jsonDecode(response.body);
        print('Data posted successfully: $jsonData');
        return jsonData;
      } else {
        // Handle non-200 responses
        _handleError(response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('An error occurred: $e');
      Fluttertoast.showToast(msg: 'Network Error: $e');
      return null;
    }
  }

  Future<dynamic> putData2(String endpoint, dynamic body) async {
    debugPrint('SEND DATA ${body}');
    try {
      // Perform the POST request
      debugPrint('URL: ${AppConstants.baseUrl}$endpoint');

      final response = await client.put(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${{AppConstants.token}}', // Optional
        },
        body: jsonEncode(body),
      );

      // Handle response based on status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final jsonData = jsonDecode(response.body);
        print('Data posted successfully: $jsonData');
        return jsonData;
      } else {
        // Handle non-200 responses
        _handleError(response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('An error occurred: $e');
      Fluttertoast.showToast(msg: 'Network Error: $e');
      return null;
    }
  }

  // Error handling based on status code
  void _handleError(int statusCode, String responseBody) {
    debugPrint('ERROR RESPONSE : ${responseBody}');
    switch (statusCode) {
      case 204:
        EasyLoading.dismiss();
        print("Not Found: $responseBody");
        var response = jsonDecode(responseBody);
        debugPrint('responseBody ${response}');

        Fluttertoast.showToast(
            msg: response['Message'] ?? "Resource Not Found",toastLength: Toast.LENGTH_LONG);
        break;
      case 400:
        EasyLoading.dismiss();
        print("Bad Request: $responseBody");
        var response = jsonDecode(responseBody);
        Fluttertoast.showToast(msg:response['Message'] ??response['msg']?? "Bad Request: $responseBody",toastLength: Toast.LENGTH_LONG);
        break;
      case 401:
        EasyLoading.dismiss();
        print("Unauthorized Access: $responseBody");

        Fluttertoast.showToast(msg: "Unauthorized Access",toastLength: Toast.LENGTH_LONG);
        break;
      case 403:
        EasyLoading.dismiss();
        print("Forbidden: $responseBody");
        Fluttertoast.showToast(msg: "Please enter valid username or password",toastLength: Toast.LENGTH_LONG);
        break;
      case 404:
        EasyLoading.dismiss();
        var response = jsonDecode(responseBody);
        debugPrint('responseBody $response');
        Fluttertoast.showToast(
            msg: response['Message'] ?? "Resource Not Found",toastLength: Toast.LENGTH_LONG);
      case 409:
        EasyLoading.dismiss();
        var response = jsonDecode(responseBody);
        debugPrint('responseBody ${response}');
        Fluttertoast.showToast(
            msg: response['Message'] ?? "Resource Not Found",toastLength: Toast.LENGTH_LONG);
        break;
      case 500:
        EasyLoading.dismiss();
        print("Internal Server Error: $responseBody");
        Fluttertoast.showToast(msg: "Internal Server Error",toastLength: Toast.LENGTH_LONG);
        break;
      default:
        EasyLoading.dismiss();
        print("Unhandled Error: $responseBody");
        Fluttertoast.showToast(msg: "Error $statusCode: $responseBody",toastLength: Toast.LENGTH_LONG);
        break;
    }
  }

  Future<dynamic> deleteData(String endpoint) async {
    try {
      // Perform the DELETE request
      debugPrint('URL: ${AppConstants.baseUrl}$endpoint');

      final response = await client.delete(
        Uri.parse('${{AppConstants.baseUrl}}${endpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${{AppConstants.token}}', // Optional
        },
      );

      // Handle response based on status code
      if (response.statusCode == 200 || response.statusCode == 204) {
        final jsonData = jsonDecode(response.body);
        print('Data deleted successfully : $jsonData');
        return jsonData; // Return success flag
      } else {
        // Handle non-200 responses
        _handleError(response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('An error occurred: $e');
      Fluttertoast.showToast(msg: 'Network Error: $e');
      return null;
    }
  }

  Future<dynamic> uploadImageWithData({
    required String url,
    required File? imageFile,
    required Map<String, dynamic> formData,
  }) async {
    try {
      EasyLoading.show(status: 'Loading..', maskType: EasyLoadingMaskType.black);
      debugPrint('Starting leave data upload with image: ${imageFile?.path}');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}$url'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer ${AppConstants.token}',
      });

      // Handle DocumentFile:
      // If imageFile exists, it overrides formData's DocumentFile.
      // If imageFile is null, formData's DocumentFile (even if null) is used.
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'DocumentFile', // Overrides any existing DocumentFile in formData
            imageFile.path,
          ),
        );
        debugPrint('Added image file as DocumentFile');
      }

      // Add all formData (including DocumentFile if imageFile is null)
      request.fields.addAll(
        formData.map((key, value) => MapEntry(key, value.toString())),
      );


      debugPrint('Request fields: ${request.fields}');
      debugPrint('Request files: ${request.files.map((f) => f.field)}');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('Server response: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(responseBody);
        EasyLoading.dismiss();
        return jsonData;
      } else {
        _handleError(response.statusCode, responseBody);
        return null;
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Upload failed: ${e.toString()}');
      return null;
    }
    finally {
      EasyLoading.dismiss();
    }
  }
}
