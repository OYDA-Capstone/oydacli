/// Returns the main content as a string for the given project name.
///
/// The main content includes import statements, the main function, and the runApp() function.
String mainContent(String projectName) => '''
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to OYDACLI'),
        ),
        body: Center(
          child: Text('Built with love by O2🖤'),
        ),
      ),
    );
  }
}

''';

/// Returns the widget test content as a string for the given project name.
///
/// The widget test content includes import statements, the main test function, and a test case.
String widgetTestContent(String projectName) => '''
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:oydadb/src/oyda_interface.dart';

// void main() async {
//   group('OYDAInterface', () {
//     test('selectTable', () async {
//       await dotenv.load(fileName: ".env");
//       var table = await OydaInterface().selectTable('test');
//       print(table);

//     });
//   });

// }
''';

/// Returns the pubspec.yaml content as a string for the given project name.
///
/// The pubspec.yaml content includes project metadata, dependencies, and dev dependencies.
String pubspecContent(String projectName) => '''

### THIS FILE IS READ-ONLY. To update project dependencies, use the 'oyda fetch' command in your terminal. ###
name: $projectName
description: A new Oyda project.
version: 1.0.0+1

environment:
  sdk: '>=3.4.0 <4.0.0'
  flutter: ">=1.17.0"

dev_dependencies:
  flutter_test:
    sdk: flutter

dependencies:
  flutter:
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

/// Default index file or something
///
///
String indexContent(String projectName) => '''
<!DOCTYPE html>
<html>
	<head>
		<base href="\$FLUTTER_BASE_HREF" />

		<meta charset="UTF-8" />
		<meta content="IE=Edge" http-equiv="X-UA-Compatible" />
		<meta name="description" content="A new Flutter project." />

		<!-- iOS meta tags & icons -->
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta name="apple-mobile-web-app-status-bar-style" content="black" />
		<meta name="apple-mobile-web-app-title" content="testapp" />
		<link rel="apple-touch-icon" href="icons/Icon-192.png" />

		<!-- Favicon -->
		<link rel="icon" type="image/png" href="favicon.png" />

		<title>testapp</title>
		<!-- <link rel="manifest" href="manifest.json"> -->
	</head>
	<body>
		<script src="flutter_bootstrap.js" async></script>
	</body>
</html>
''';

/// Default IML file
String testIMLContent() => '''
<?xml version="1.0" encoding="UTF-8"?>
<module type="JAVA_MODULE" version="4">
  <component name="NewModuleRootManager" inherit-compiler-output="true">
    <exclude-output />
    <content url="file://\$MODULE_DIR\$">
      <sourceFolder url="file://\$MODULE_DIR\$/lib" isTestSource="false" />
      <sourceFolder url="file://\$MODULE_DIR\$/test" isTestSource="true" />
      <excludeFolder url="file://\$MODULE_DIR\$/.dart_tool" />
      <excludeFolder url="file://\$MODULE_DIR\$/.idea" />
      <excludeFolder url="file://\$MODULE_DIR\$/build" />
    </content>
    <orderEntry type="sourceFolder" forTests="false" />
    <orderEntry type="library" name="Dart SDK" level="project" />
    <orderEntry type="library" name="Flutter Plugins" level="project" />
    <orderEntry type="library" name="Dart Packages" level="project" />
  </component>
</module>
''';

//Default oydaBase Config file
String tableConfigContent() => '''
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oydadb/src/oyda_interface.dart';

void main() async {
// Create a new table in the OydaBase
// Replace test_table with the name of the table you want to create in your oydabase
  await OydaInterface().createTable('test_table', {'name': 'VARCHAR(255)', 'age': 'INTEGER'});

// Drop an existing table from the OydaBase
// Replace test_table with the name of the table you want to drop
  await OydaInterface().dropTable('test_table');
}
''';

String gitignoreContent() => '''
# Created by `oydacli create`

.dart_tool/
.env
''';
