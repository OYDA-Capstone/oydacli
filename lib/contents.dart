/// Returns the main content as a string for the given project name.
///
/// The main content includes import statements, the main function, and the runApp() function.
String mainContent(String projectName) => '''
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
String widgetTestContent(String projectName) => '''
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
String pubspecContent(String projectName) => '''
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
String envContent(String host, int port, String oydaBase, String user, String password, int devKey) => '''
HOST=$host
PORT=$port
OYDABASE=$oydaBase
USER=$user
PASSWORD=$password
DEV_KEY=$devKey
''';
