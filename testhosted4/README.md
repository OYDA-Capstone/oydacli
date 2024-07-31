
# testhosted4

oydacli is a command-line application designed to streamline the creation of new Oyda projects. 
It automates the setup process, including the creation of project directories, initialization of Dart and Flutter files, 
and configuration of environment variables for database connections.

## Getting Started
- In the `lib` directory, you will find the `main.dart` file which contains the main function and is the entry point of the application.
- In the `test` directory, you will find the `widget_test.dart` file where you can write your tests.
- In the `web` directory, you will find the `index.html` file which is the entry point of the web application.

## Creation and Dropping of Database Tables
- In the `config` directory, you will find the `table.dart` file where you can create and drop tables in the OydaBase, using the format shown in the examples.

## Using Packages
As part of efforts to enhance independent development, the project approaches the use of packages with caution.
Although there is a `pubspec.yaml` file in the root directory, it is meant to be read-only, to ensure that all developers are using the same versions of packages.
For this reason, the `pubspec.yaml` file is included in the `.gitignore` file to prevent it from being pushed to the repository as it is to be used only for reference locally.
To add a project dependency (into the shared project dependencies table), use the `oyda add` command in your terminal.
First, change the directory by moving one level up from the project root directory, then run the command:
 `oydacli add --projectName <project_name> --package <package_name>`

 To update project dependencies to your local pubspec file, use the 'oyda fetch' command in your terminal:
  `oydacli fetch --projectName <project_name>`

## Environment Variables
In the `.env` file, you will find the environment variables for the database connection.

## Running the Application
Currently, the application is set up to run on the web platform. To run the application, use the following command:
`oydacli run`
