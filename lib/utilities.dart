import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Sets the Oydabase configuration by sending a POST request to the specified API endpoint.
///
/// The function takes in the [host], [port], [oydaBase], [user], and [password] parameters
/// to construct the request body. It then sends the request to the API endpoint and
/// handles the response accordingly.
///
/// If the request is successful (status code 200), it prints a success message and returns true.
/// Otherwise, it prints the error message from the response body and returns false.
///
/// If an error occurs during the request, it prints the error message and returns false.
Future<bool> setOydabase(String host, int port, String oydaBase, String user, String password) async {
  final url = Uri.parse('http://localhost:5000/api/setOydabase');
  final Map<String, dynamic> requestBody = {
    'host': host,
    'port': port,
    'oydaBase': oydaBase,
    'user': user,
    'password': password,
  };
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Connected to Oydabase @ $host:$port/$oydaBase.');
      return true;
    } else {
      final responseBody = json.decode(response.body);
      print('Error: ${responseBody['error']}');
      return false;
    }
  } catch (e) {
    print('Error connecting to the Oydabase: $e');
    return false;
  }
}

/// Makes a file read-only by changing its permissions to 444.
///
/// Returns `true` if the file was successfully made read-only,
/// otherwise returns `false`.
bool makeReadOnly(String filePath) {
  try {
    final result = Process.runSync('chmod', ['444', filePath]);

    if (result.exitCode == 0) {
      return true;
    } else {
      print('Failed to make file read-only: ${result.stderr}');
      return false;
    }
  } catch (e) {
    print('Error making file read-only: $e');
    return false;
  }
}
