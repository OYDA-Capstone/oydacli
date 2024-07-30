import 'dart:io';
import 'contents.dart';
import 'utilities.dart';
import 'package:path/path.dart' as path;

/// Creates a new Oyda project with the given parameters.
///
/// - The `projectName` is the name of the project to be created.
/// - The `host` is the host address of the oydabase.
/// - The `port` is the port number of the oydabase.
/// - The `oydaBase` is the name of the oydabase.
/// - The `user` is the username for authentication.
/// - The `password` is the password for authentication.
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
Future<void> createProject(String projectName, String host, int port,
    String oydaBase, String user, String password) async {
  print('Creating project $projectName...');
  final result = await setOydabase(host, port, oydaBase, user, password);
  final bool isConnected = result['success'];
  final int devKey = result['dev_key'];

  if (!isConnected) {
    print(
        'Failed to connect to the oydabase. Check that the oydabase with these parameters exists and is running. \n Project creation aborted.');
    return;
  }

  createDirectory(projectName);
  createMainFile(projectName);
  createIndexFile(projectName);
  createWidgetTestFile(projectName);
  createReadmeFile(projectName);
  createTestIMLFile(projectName);
  createEnvFile(projectName, host, port, oydaBase, user, password, devKey);
  createDependenciesFile(projectName);
  createPubspecFile(projectName);
  createTableConfigFile(projectName);
  copyDefaultImage(projectName);
  createGitignoreFile(projectName);
  await addDefaultDependencies(projectName);
  await fetchDependencies(projectName);
  print('Project $projectName created successfully.');
  print(
      'To start the project, run the following command:  \noydacli run --projectName $projectName');
}

void createDirectory(String path) {
  final Directory dir = Directory(path);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
}

void createFile(String path, String content) {
  final File file = File(path);
  if (!file.existsSync()) {
    file.writeAsStringSync(content);
  }
}

void createMainFile(String projectName) {
  createDirectory('$projectName/lib');
  createFile('$projectName/lib/main.dart', mainContent(projectName));
}

void createIndexFile(String projectName) {
  createDirectory('$projectName/web');
  createFile('$projectName/web/index.html', indexContent(projectName));
}

void createWidgetTestFile(String projectName) {
  createDirectory('$projectName/test');
  createFile(
      '$projectName/test/widget_test.dart', widgetTestContent(projectName));
}

void createReadmeFile(String projectName) {
  createFile('$projectName/README.md', readmeContent(projectName));
}

void createTestIMLFile(String projectName) {
  createFile('$projectName/test.iml', testIMLContent());
}

void createEnvFile(String projectName, String host, int port, String oydaBase,
    String user, String password, int devKey) {
  createFile('$projectName/.env',
      envContent(host, port, oydaBase, user, password, devKey));
}

void createDependenciesFile(String projectName) {
  createFile('$projectName/dependencies.txt', 'dependencies: \n\n');
}

void createPubspecFile(String projectName) {
  createFile('$projectName/pubspec.yaml', pubspecContent(projectName));
}

void createTableConfigFile(String projectName) {
  createDirectory('$projectName/config');
  createFile('$projectName/config/table.dart', tableConfigContent());
}

void createGitignoreFile(String projectName) {
  createFile('$projectName/.gitignore', gitignoreContent());
}

// void createBackgroundFIle(String projectName) {
//   createDirectory('$projectName/assets');
//   createFile('assets/background.jpg', backgroundContent());
// }

void copyDefaultImage(String projectName) {
  final imageSource = path.join('assets', 'background.png');
  final imageDestination = path.join(projectName, 'assets', 'background.png');

  Directory(path.join(projectName, 'assets')).createSync(recursive: true);

  final imageFile = File(imageSource);
  if (imageFile.existsSync()) {
    imageFile.copySync(imageDestination);
  } else {
    print('Default image not found');
  }
}

Future<void> addDefaultDependencies(String projectName) async {
  const List<String> defaultDependencies = ['flutter_dotenv', 'oydadb'];
  for (String dependency in defaultDependencies) {
    await addDependency(projectName, dependency);
  }
}
