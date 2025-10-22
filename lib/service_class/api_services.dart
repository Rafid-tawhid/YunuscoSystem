import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as client;
import 'package:http_interceptor/http/intercepted_client.dart';
import '../helper_class/dashboard_helpers.dart';
import '../utils/constants.dart';
import 'interceptor_class.dart'; // Optional for error message display

class ApiService {
  // Define base URL
  final String baseUrl = AppConstants.baseUrl;

  // Create the client with the interceptor
  final client = InterceptedClient.build(interceptors: [
    CustomInterceptor(),
  ]);

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
      final response = await client.get(Uri.parse(endpoint)).timeout(Duration(seconds: 10));

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

      final response = await client
          .post(
            Uri.parse('${AppConstants.baseUrl}$endpoint/'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${{AppConstants.token}}', // Optional
            },
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: 10));

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

  Future<dynamic> patchData(String endpoint, dynamic body) async {
    try {
      // Perform the POST request
      debugPrint('pre URL: ${AppConstants.baseUrl}$endpoint/');
      debugPrint('My Sending Data: $body');

      final response = await client
          .patch(
            Uri.parse('${AppConstants.baseUrl}$endpoint/'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${{AppConstants.token}}', // Optional
            },
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: 10));

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

      final response = await client
          .post(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AppConstants.token}', // Optional
            },
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: 10));

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
    debugPrint('SEND DATA $body');
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

  Future<Map<String, dynamic>?> postFormData(String endpoint, Map<String, dynamic> body) async {
    debugPrint('SEND URL: ${AppConstants.baseUrl + endpoint}');
    debugPrint('SEND DATA: ${json.encode(body)}');

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(AppConstants.baseUrl + endpoint),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer ${AppConstants.token}';
      request.headers['Accept'] = 'application/json';

      // Add fields
      body.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Send the request and get response
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      final statusCode = response.statusCode;

      debugPrint('Response Status Code: $statusCode');
      debugPrint('Response Body: $responseString');

      // Parse response
      final responseJson = json.decode(responseString) as Map<String, dynamic>;

      if (statusCode >= 200 && statusCode < 300) {
        // Success - return the response body
        return responseJson;
      } else {
        // Server returned error - extract error message from common field names
        final errorMessage = responseJson['message'] ?? responseJson['error'] ?? responseJson['detail'] ?? 'Request failed with status $statusCode';

        debugPrint('Server Error: $errorMessage');

        // Use your existing alert system instead of undefined _handleError
        DashboardHelpers.showAlert(msg: errorMessage);
        return null;
      }
    } on SocketException catch (e) {
      // Handle network connectivity issues
      debugPrint('Network Error: $e');
      DashboardHelpers.showAlert(msg: 'Network error: Please check your internet connection');
      return null;
    } on http.ClientException catch (e) {
      // Handle client exceptions (network issues)
      debugPrint('Client Exception: $e');
      DashboardHelpers.showAlert(msg: 'Network error: ${e.message}');
      return null;
    } on FormatException catch (e) {
      // Handle JSON parsing errors
      debugPrint('JSON Format Error: $e');
      DashboardHelpers.showAlert(msg: 'Data format error: Invalid server response');
      return null;
    } catch (e) {
      // Handle all other exceptions
      debugPrint('Unexpected Error: $e');
      DashboardHelpers.showAlert(msg: 'Unexpected error: ${e.toString()}');
      return null;
    }
  }

  // Error handling based on status code
  void _handleError(int statusCode, String responseBody) {
    debugPrint('ERROR RESPONSE : $responseBody');
    switch (statusCode) {
      case 204:
        EasyLoading.dismiss();
        print("Not Found: $responseBody");
        var response = jsonDecode(responseBody);
        debugPrint('responseBody $response');

        Fluttertoast.showToast(msg: response['Message'] ?? "Resource Not Found", toastLength: Toast.LENGTH_LONG);
        break;
      case 400:
        EasyLoading.dismiss();
        print("Bad Request: $responseBody");
        var response = jsonDecode(responseBody);
        Fluttertoast.showToast(msg: response['Message'] ?? response['msg'] ?? "Bad Request: $responseBody", toastLength: Toast.LENGTH_LONG);
        break;
      case 401:
        EasyLoading.dismiss();
        print("Unauthorized Access: $responseBody");

        Fluttertoast.showToast(msg: "Unauthorized Access", toastLength: Toast.LENGTH_LONG);
        break;
      case 403:
        EasyLoading.dismiss();
        print("Forbidden: $responseBody");
        Fluttertoast.showToast(msg: "Please enter valid username or password", toastLength: Toast.LENGTH_LONG);
        break;
      case 404:
        EasyLoading.dismiss();
        var response = jsonDecode(responseBody);
        debugPrint('responseBody $response');
        Fluttertoast.showToast(msg: response['Message'] ?? "Resource Not Found", toastLength: Toast.LENGTH_LONG);
      case 409:
        EasyLoading.dismiss();
        var response = jsonDecode(responseBody);
        debugPrint('responseBody $response');
        Fluttertoast.showToast(msg: response['Message'] ?? "Resource Not Found", toastLength: Toast.LENGTH_LONG);
        break;
      case 500:
        EasyLoading.dismiss();
        print("Internal Server Error: $responseBody");
        Fluttertoast.showToast(msg: "Internal Server Error", toastLength: Toast.LENGTH_LONG);
        break;
      default:
        EasyLoading.dismiss();
        print("Unhandled Error: $responseBody");
        Fluttertoast.showToast(msg: "Error $statusCode: $responseBody", toastLength: Toast.LENGTH_LONG);
        break;
    }
  }

  Future<dynamic> deleteData(String url) async {
    try {
      // Perform the DELETE request
      debugPrint('URL: ${url}');

      final response = await client.delete(
        Uri.parse(url),
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
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<dynamic> getDataWithReturn(String endpoint) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl$endpoint')).timeout(const Duration(seconds: 5)); // Add timeout

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body.replaceAll('â', '’').replaceAll('â', '“').replaceAll('â', '”').replaceAll('â¦', '…'));
        print('Data received: $jsonData');
        return jsonData;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> postDataWithReturn(String endpoint, dynamic body) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint/');

      final response = await client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AppConstants.token}',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(decodedBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Data received success: $jsonData');
        jsonData['success'] = true;
        return jsonData;
      } else {
        print('❌ Server responded with error: $jsonData');
        return {
          'success': false,
          'message': jsonData['message'] ?? 'Unknown server error',
        };
      }
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<dynamic> getData3(String endpoint) async {
    try {
      debugPrint('API CALLING $endpoint');
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${{AppConstants.token}}',
        },
      ).timeout(const Duration(seconds: 30));
      debugPrint('Response ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
