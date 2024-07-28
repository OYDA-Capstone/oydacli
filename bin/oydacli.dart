#!/usr/bin/env dart

import 'package:args/args.dart';
import 'package:oydacli/create.dart';
import 'package:oydacli/utilities.dart';

/// The main entry point of the OYDA CLI application.
void main(List<String> arguments) async {
  final parser = ArgParser()

    /// The `create` command allows the user to create a new project with the specified options.
    //
    // Options:
    /// - `name`: The name of the project.
    /// - `host`: The host of the database.
    /// - `port`: The port of the database. Defaults to '5432'.
    /// - `oydaBase`: The name of the Oydabase.
    /// - `user`: The username for the database.
    /// - `password`: The password for the database.
    ..addCommand(
        'create',
        ArgParser()
          ..addOption('projectName', abbr: 'n', help: 'Project name')
          ..addOption('host', abbr: 'h', help: 'Database host')
          ..addOption('port',
              abbr: 'p', help: 'Database port', defaultsTo: '5432')
          ..addOption('oydaBase', abbr: 'o', help: 'Oydabase name')
          ..addOption('user', abbr: 'u', help: 'Database username')
          ..addOption('password', abbr: 'w', help: 'Database password'))

    /// The `fetch` command allows the user to fetch the dependencies for the current project.
    ///
    // Options:
    /// - `name`: The name of the project.
    ..addCommand('fetch',
        ArgParser()..addOption('projectName', abbr: 'n', help: 'Project name'))

    /// The `add` command allows the user to add a new package dependency.
    //
    // Option:
    /// - `package`: The name of the package to add.
    ..addCommand(
        'add',
        ArgParser()
          ..addOption('projectName', abbr: 'a', help: 'Project name')
          ..addOption('package', abbr: 'p', help: 'Package name'))

    /// The `run` command allows the user to run `flutter run -d chrome`.
    ..addCommand('run',
        ArgParser()..addOption('projectName', abbr: 'p', help: 'Project name'))
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Show this help message');

  final ArgResults argResults = parser.parse(arguments);

  // Show help message
  if (argResults['help'] as bool) {
    print(parser.usage);
    return;
  }

  // Handle `create` command
  if (argResults.command?.name == 'create') {
    final String? projectName = argResults.command?['projectName'];
    final String? host = argResults.command?['host'];
    final int port = int.parse(argResults.command?['port'] ?? '5432');
    final String? oydaBase = argResults.command?['oydaBase'];
    final String? user = argResults.command?['user'];
    final String? password = argResults.command?['password'];

    if (projectName != null &&
        host != null &&
        oydaBase != null &&
        user != null &&
        password != null) {
      await createProject(projectName, host, port, oydaBase, user, password);
    } else {
      print(
          'Project name, host, Oydabase, username, and password are required. Use --projectName <project_name>, --host <host>, --oydaBase <database_name>, --user <username>, and --password <password>.');
    }

    // Handle `fetch` command
  } else if (argResults.command?.name == 'fetch') {
    final String? projectName = argResults.command?['projectName'];
    if (projectName != null) {
      await fetchDependencies(projectName);
    } else {
      print('Project name is required. Use --projectName <project_name>.');
    }

    // Handle `add` command
  } else if (argResults.command?.name == 'add') {
    final String? package = argResults.command?['package'];
    final String? projectName = argResults.command?['projectName'];
    if (package != null && projectName != null) {
      await addDependency(projectName, package);
    } else {
      print(
          'Project name and package name are required. Use --projectName <project_name>, --package <package_name>.');
    }

    // Default usage message
  }
  // Handle `run` command
  else if (argResults.command?.name == 'run') {
    runProject(argResults.command?['projectName']);
  } else {
    print('');
    print(
        'The OYDA CLI helps you create and manage your OYDA projects with ease.');
    print('');
    print('Usage:');
    print(
        '  oydacli create --name <project_name> --host <host> --port <port> --oydaBase <database_name> --user <username> --password <password>');
    print(
        '    Create a new OYDA project with the specified name and database connection details.');
    print('');
    print('  oydacli fetch');
    print('    Fetch the dependencies for the current OYDA project.');
    print('');
    print(
        '  oydacli add -- projectName <project_name> --package <package_name>');
    print('    Add a new package dependency to the current OYDA project.');
    print('');
    print('Options:');
    print('  --projectName, -n        Project name');
    print('  --host, -h        Database host');
    print('  --port, -p        Database port (default: 5432)');
    print('  --oydaBase, -o    Oydabase name');
    print('  --user, -u        Database username');
    print('  --password, -w    Database password');
    print('  --package, -p     Package name (for add command)');
    print('  --help, -h        Show this help message');
  }
}
