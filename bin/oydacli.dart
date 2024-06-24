#!/usr/bin/env dart

import 'package:args/args.dart';
import 'package:oydacli/create.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand(
        'create',
        ArgParser()
          ..addOption('name', abbr: 'n', help: 'Project name')
          ..addOption('host', abbr: 'h', help: 'Database host')
          ..addOption('port', abbr: 'p', help: 'Database port', defaultsTo: '5432')
          ..addOption('oydaBase', abbr: 'o', help: 'Oydabase name')
          ..addOption('user', abbr: 'u', help: 'Database username')
          ..addOption('password', abbr: 'w', help: 'Database password'));

  final ArgResults argResults = parser.parse(arguments);

  if (argResults.command?.name == 'create') {
    final String? projectName = argResults.command?['name'];
    final String? host = argResults.command?['host'];
    final int port = int.parse(argResults.command?['port'] ?? '5432');
    final String? oydaBase = argResults.command?['oydaBase'];
    final String? user = argResults.command?['user'];
    final String? password = argResults.command?['password'];

    if (projectName != null && host != null && oydaBase != null && user != null && password != null) {
      createProject(projectName, host, port, oydaBase, user, password);
    } else {
      print('All database connection parameters are required. Use --host, --port, --oydaBase, --user, and --password.');
    }
  } else {
    print(
        'Usage: oyda create --name <project_name> --host <host> --port <port> --oydaBase <database_name> --user <username> --password <password>');
  }
}
