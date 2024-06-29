import 'dart:io';
import 'utilities.dart';

/// Creates a new Oyda project with the given parameters.
///
/// The [projectName] is the name of the project to be created.
/// The [host] is the host address of the oydabase.
/// The [port] is the port number of the oydabase.
/// The [oydaBase] is the name of the oydabase.
/// The [user] is the username for authentication.
/// The [password] is the password for authentication.
///
/// This function connects to the oydabase using the provided parameters.
/// If the connection is successful, it creates a new directory with the [projectName].
/// Inside the project directory, it creates the necessary subdirectories and files
/// for an Oyda project, including 'lib/main.dart', 'test/widget_test.dart',
/// 'README.md', and '.env' files.
/// It also sets the 'pubspec.yaml' file to read-only.
///
/// If the connection to the oydabase fails or the project directory already exists,
/// appropriate error messages are printed and the function returns.
///
/// After successfully creating the project, a success message is printed.
Future<void> createProject(String projectName, String host, int port, String oydaBase, String user, String password) async {
  final bool isConnected = await setOydabase(host, port, oydaBase, user, password);

  if (!isConnected) {
    print(
        'Failed to connect to the oydabase. Check that the oydabase with these parameters exists and is running. \n Project creation aborted.');
    return;
  }

  final Directory projectDir = Directory(projectName);

  if (projectDir.existsSync()) {
    print('Directory $projectName already exists.');
    return;
  }

  projectDir.createSync();

  Directory('$projectName/lib').createSync(recursive: true);
  File('$projectName/lib/main.dart').writeAsStringSync(_mainContent(projectName));
  Directory('$projectName/test').createSync(recursive: true);
  File('$projectName/test/widget_test.dart').writeAsStringSync(_widgetTestContent(projectName));
  File('$projectName/README.md').writeAsStringSync('# $projectName\n\nA new Oyda project.');
  File('$projectName/.env').writeAsStringSync(_envContent(host, port, oydaBase, user, password));

  // Set the pubspec.yaml file to read-only
  final pubspecFile = File('$projectName/pubspec.yaml');
  pubspecFile.writeAsStringSync(_pubspecContent(projectName));

  if (makeReadOnly(pubspecFile.path)) {
    print('pubspec.yaml now read-only.');
  } else {
    print('Failed to make pubspec.yaml to read-only.');
  }

  print('Project $projectName created successfully.');
}

/// Returns the main content as a string for the given project name.
///
/// The main content includes import statements, the main function, and the runApp() function.
String _mainContent(String projectName) => '''
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:oydadb/src/oyda_interface.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await dotenv.load(fileName: ".env");
//   var table = await OydaInterface().selectTable('test');
//   print(table);
//   runApp(const MyApp());
// }
''';

/// Returns the widget test content as a string for the given project name.
///
/// The widget test content includes import statements, the main test function, and a test case.
String _widgetTestContent(String projectName) => '''
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oydadb/src/oyda_interface.dart';

void main() async {
  group('OYDAInterface', () {
    test('selectTable', () async {
      await dotenv.load(fileName: ".env");
      var table = await OydaInterface().selectTable('test');
      print(table);

    });
  });

}
''';

/// Returns the pubspec.yaml content as a string for the given project name.
///
/// The pubspec.yaml content includes project metadata, dependencies, and dev dependencies.
String _pubspecContent(String projectName) => '''
### THIS FILE IS READ-ONLY. To update project dependencies, use the 'oyda update' command. ###

name: $projectName
description: A new Oyda project.
version: 1.0.0+1

environment:
  sdk: '>=3.4.0 <4.0.0'
  flutter: ">=1.17.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_dotenv: ^5.1.0
  http: ^1.2.1
  oydadb: ^1.0.3

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - .env

''';

/// Returns the .env file content as a string for the given host, port, OYDA base, user, and password.
///
/// The .env file content includes environment variable assignments for host, port, OYDA base, user, and password.
String _envContent(String host, int port, String oydaBase, String user, String password) {
  return '''
HOST=$host
PORT=$port
OYDA_BASE=$oydaBase
USER=$user
PASSWORD=$password
''';
}
