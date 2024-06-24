import 'dart:io';
import 'utilities.dart';

void createProject(String projectName, String host, int port, String oydaBase, String user, String password) async {
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

String _mainContent(String projectName) => '''
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  var table = await OydaInterface().selectTable('test');
  print(table);
  runApp(const MyApp());
}
''';

String _widgetTestContent(String projectName) => '''
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../oydadb/src/oyda_interface.dart';

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

String _pubspecContent(String projectName) => '''
### THIS FILE IS READ-ONLY. To update project dependencies, use the 'oyda update' command. ###

name: testproj
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

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - .env

''';

String _envContent(String host, int port, String oydaBase, String user, String password) {
  return '''
HOST=$host
PORT=$port
OYDA_BASE=$oydaBase
USER=$user
PASSWORD=$password
''';
}
