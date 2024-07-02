import 'dart:io';
import 'contents.dart';
import 'utilities.dart';

/// Creates a new Oyda project with the given parameters.
///
/// - The `projectName` is the name of the project to be created.
/// - The `host` is the host address of the oydabase.
/// The `port` is the port number of the oydabase.
/// The `oydaBase` is the name of the oydabase.
/// The `user` is the username for authentication.
/// The `password` is the password for authentication.
///
/// This function connects to the oydabase using the provided parameters.
/// If the connection is successful, it creates a new directory with the `projectName`.
/// Inside the project directory, it creates the necessary subdirectories and files
/// for an Oyda project, including 'lib/main.dart', 'test/widget_test.dart',
/// 'README.md', and '.env' files.
/// It also sets the 'pubspec.yaml' file to read-only.
///
/// If the connection to the oydabase fails or the project directory already exists,
/// appropriate error messages are printed and the function returns.
///
/// After successfully creating the project, a success message is printed.
Future<void> createProject(
    String projectName, String host, int port, String oydaBase, String user, String password) async {
  print('Creating project $projectName...');
  final result = await setOydabase(host, port, oydaBase, user, password);
  final bool isConnected = result['success'];
  final int devKey = result['dev_key'];

  if (!isConnected) {
    print(
        'Failed to connect to the oydabase. Check that the oydabase with these parameters exists and is running. \n Project creation aborted.');
    return;
  }

  // create project directory
  final Directory projectDir = Directory(projectName);
  if (projectDir.existsSync()) {
    print('Directory $projectName already exists.');
    return;
  }
  projectDir.createSync(recursive: true);

  // create project files

  // main.dart
  Directory('$projectName/lib').createSync(recursive: true);
  final main = File('$projectName/lib/main.dart');
  if (!main.existsSync()) {
    main.writeAsStringSync(mainContent(projectName));
  }

  // widget_test.dart
  Directory('$projectName/test').createSync(recursive: true);
  final widgetTest = File('$projectName/test/widget_test.dart');
  if (!widgetTest.existsSync()) {
    widgetTest.writeAsStringSync(widgetTestContent(projectName));
  }

  // README.md
  final readme = File('$projectName/README.md');
  if (!readme.existsSync()) {
    readme.writeAsStringSync('# $projectName\n\nA new Oyda project.');
  }

  // .env
  final env = File('$projectName/.env');
  if (!env.existsSync()) {
    env.writeAsStringSync(envContent(host, port, oydaBase, user, password, devKey));
  }

  // dependencies.txt
  final dependencies = File('$projectName/dependencies.txt');
  if (!dependencies.existsSync()) {
    dependencies.writeAsStringSync('dependencies: \n\n');
  }

  // pubspec.yaml
  final pubspecFile = File('$projectName/pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    pubspecFile.writeAsStringSync(pubspecContent(projectName));
    // setPubspecReadOnly(projectName, pubspecContent(projectName));
    if (makeReadOnly(pubspecFile.path)) {
      print('pubspec.yaml now read-only.');
    } else {
      print('Failed to make pubspec.yaml to read-only.');
    }
  }

  print('Project $projectName created successfully.');
  fetchDependencies(projectName);
}


