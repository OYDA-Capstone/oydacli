#!/usr/bin/env dart
import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser()..addCommand('create', ArgParser()..addOption('name', abbr: 'n'));

  final ArgResults argResults = parser.parse(arguments);

  if (argResults.command?.name == 'create') {
    final String? projectName = argResults.command?['name'];
    if (projectName != null) {
      createProject(projectName);
    } else {
      print('Project name is required. Use --name or -n to specify the project name.');
    }
  } else {
    print('Usage: oyda create --name <project_name>');
  }
}

void createProject(String projectName) {
  final Directory projectDir = Directory(projectName);

  if (projectDir.existsSync()) {
    print('Directory $projectName already exists.');
    return;
  }

  projectDir.createSync();

  // Create subdirectories and files
  Directory('$projectName/lib').createSync(recursive: true);
  Directory('$projectName/test').createSync(recursive: true);
  File('$projectName/pubspec.yaml').writeAsStringSync(_pubspecContent(projectName));
  File('$projectName/README.md').writeAsStringSync('# $projectName\n\nA new Oyda project.');
  // File('$projectName/lib/main.dart').writeAsStringSync(_mainDartContent());

  print('Project $projectName created successfully.');
}

String _pubspecContent(String projectName) => '''
name: $projectName
description: A new Oyda project.
version: 1.0.0+1

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  oydadb: ^0.0.2 

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
''';
