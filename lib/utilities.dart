import 'dart:io';
import 'dart:convert';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

/// Sets the Oydabase configuration by sending a POST request to the specified API endpoint.
///
/// The function takes in the `host`, `port`, `oydaBase`, `user`, and `password` parameters
/// to construct the request body. It then sends the request to the API endpoint and
/// handles the response accordingly.
///
/// If the request is successful (status code 200), it prints a success message and returns true.
/// Otherwise, it prints the error message from the response body and returns false.
///
/// If an error occurs during the request, it prints the error message and returns false.
Future<Map<String, dynamic>> setOydabase(String host, int port, String oydaBase, String user, String password) async {
  final url = Uri.parse('http://localhost:5000/api/set_oydabase');
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
      final responseBody = json.decode(response.body);
      print('${responseBody['message']}');
      print('Dev Key: ${responseBody['dev_key']}');
      return {'success': true, 'dev_key': responseBody['dev_key']};
    } else {
      final responseBody = json.decode(response.body);
      print('Error: ${responseBody['error']}');
      return {'success': false, 'dev_key': null};
    }
  } catch (e) {
    print('Error connecting to the Oydabase: $e');
    return {'success': false, 'dev_key': null};
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

/// Sets the pubspec.yaml file as read-only.
///
/// The function takes in the `projectName` and the `pubspec` content to write into the file.
/// After writing the content, it attempts to make the file read-only.
/// Prints success or failure message based on the outcome.
void setPubspecReadOnly(String projectName, String pubspec) {
  final pubspecFile = File('$projectName/pubspec.yaml');
  pubspecFile.writeAsStringSync(pubspec);

  if (makeReadOnly(pubspecFile.path)) {
    print('pubspec.yaml now read-only.');
  } else {
    print('Failed to make pubspec.yaml read-only.');
  }
}

/// Fetches the dependencies from the Oydabase.
///
/// The function loads environment variables from the `.env` file to get the necessary
/// connection parameters. It then sends a POST request to the API endpoint to fetch
/// the dependencies.
///
/// If the request is successful, it returns a list of dependencies as strings.
/// If an error occurs, it prints the error message and returns an empty list.
Future<List<String>> getDependencies() async {
  var env = DotEnv(includePlatformEnvironment: true);
  env.load(['.env']);

  String? host = env['HOST'];
  int? port = int.tryParse(env['PORT']!);
  String? oydaBase = env['OYDABASE'];
  String? user = env['USER'];
  String? password = env['PASSWORD'];

  if (host == null || port == null || oydaBase == null || user == null || password == null) {
    print('Error: Missing required connection parameters.');
    return [];
  }

  final url = Uri.parse('http://localhost:5000/api/get_dependencies');
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
      final responseBody = json.decode(response.body);
      return responseBody['dependencies'].cast<String>();
    } else {
      final responseBody = json.decode(response.body);
      print('Error: ${responseBody['error']}');
      return [];
    }
  } catch (e) {
    print('Error connecting to the Oydabase: $e');
    return [];
  }
}

/// Fetches the dependencies for the specified project.
///
/// The function checks if the `pubspec.yaml` and `.env` files exist in the specified `projectName`
/// directory. If they do, it fetches the dependencies using `getDependencies` and writes them
/// to a `dependencies.txt` file within the project directory.
///
/// Prints appropriate messages based on the outcome.
Future<void> fetchDependencies(String? projectName) async {
  final File pubspecFile = File('$projectName/pubspec.yaml');
  final File envFile = File('$projectName/.env');

  if (!pubspecFile.existsSync() || !envFile.existsSync()) {
    print('This command must be run in the directory of an Oyda project.');
    return;
  }

  final List<String> dependencies = await getDependencies();
  if (dependencies.isNotEmpty) {
    final File dependenciesFile = File('$projectName/dependencies.txt');
    dependenciesFile.writeAsStringSync('dependencies:\n' + dependencies.join('\n'));
    print('Dependencies written to dependencies.txt');
  } else {
    print('No dependencies found.');
  }
}

/// Adds a dependency to the Oydabase.
///
/// The function loads environment variables from the `.env` file to get the necessary
/// connection parameters. It then sends a POST request to the API endpoint to add
/// the specified `packageName`.
///
/// If the request is successful, it prints a success message.
/// If an error occurs, it prints the error message.
Future<void> addDependency(String packageName) async {
  var env = DotEnv(includePlatformEnvironment: true);
  env.load(['.env']);

  String? host = env['HOST'];
  int? port = int.tryParse(env['PORT']!);
  String? oydaBase = env['OYDABASE'];
  String? user = env['USER'];
  String? password = env['PASSWORD'];

  if (host == null || port == null || oydaBase == null || user == null || password == null) {
    print('Error: Missing required connection parameters.');
    return;
  }
  final url = Uri.parse('http://localhost:5000/api/add_dependency');
  final Map<String, dynamic> requestBody = {
    'host': host,
    'port': port,
    'oydaBase': oydaBase,
    'user': user,
    'password': password,
    'package_name': packageName,
  };
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      print('${responseBody['message']}');
    } else {
      final responseBody = json.decode(response.body);
      print('Error: ${responseBody['error']}');
    }
  } catch (e) {
    print('Error connecting to the Oydabase: $e');
  }
}
