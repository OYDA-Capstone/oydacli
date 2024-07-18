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
          ..addOption('name', abbr: 'n', help: 'Project name')
          ..addOption('host', abbr: 'h', help: 'Database host')
          ..addOption('port', abbr: 'p', help: 'Database port', defaultsTo: '5432')
          ..addOption('oydaBase', abbr: 'o', help: 'Oydabase name')
          ..addOption('user', abbr: 'u', help: 'Database username')
          ..addOption('password', abbr: 'w', help: 'Database password'))

    /// The `fetch` command allows the user to fetch the dependencies for the current project.
    ///
    // Options:
    /// - `name`: The name of the project.
    ..addCommand('fetch', ArgParser()..addOption('name', abbr: 'n', help: 'Project name'))

    /// The `add` command allows the user to add a new package dependency.
    //
    // Option:
    /// - `package`: The name of the package to add.
    ..addCommand('add', ArgParser()..addOption('package', abbr: 'p', help: 'Package name'));

  final ArgResults argResults = parser.parse(arguments);

  // Handle `create` command
  if (argResults.command?.name == 'create') {
    final String? projectName = argResults.command?['name'];
    final String? host = argResults.command?['host'];
    final int port = int.parse(argResults.command?['port'] ?? '5432');
    final String? oydaBase = argResults.command?['oydaBase'];
    final String? user = argResults.command?['user'];
    final String? password = argResults.command?['password'];

    if (projectName != null && host != null && oydaBase != null && user != null && password != null) {
      await createProject(projectName, host, port, oydaBase, user, password);
    } else {
      print('All database connection parameters are required. Use --host, --port, --oydaBase, --user, and --password.');
    }

    // Handle `fetch` command
  } else if (argResults.command?.name == 'fetch') {
    final String? projectName = argResults.command?['name'];
    await fetchDependencies(projectName);

    // Handle `add` command
  } else if (argResults.command?.name == 'add') {
    final String? package = argResults.command?['package'];
    if (package != null) {
      await addDependency(package);
    } else {
      print('Package name is required. Use --package.');
    }

    // Default usage message
  } else {
    print('Usage:');
    print(
        '  oyda create --name <project_name> --host <host> --port <port> --oydaBase <database_name> --user <username> --password <password>');
    print('  oyda fetch');
    print('  oyda add --package <package_name>');
  }
}
