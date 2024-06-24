# oydacli

oydacli is a command-line application designed to streamline the creation of new Oyda projects. It automates the setup process, including the creation of project directories, initialization of Dart and Flutter files, and configuration of environment variables for database connections.

## Features

- **Project Initialization**: Automatically generates a new project structure, including necessary directories (`lib/`, `test/`) and starter files (`main.dart`, `widget_test.dart`, `README.md`).

- **Database Configuration**: Sets up a `.env` file with database connection parameters (`host`, `port`, `oydaBase`, `user`, `password`), facilitating easy and secure access to your Oyda database.

- **Read-Only Configuration**: Makes the `pubspec.yaml` file read-only to prevent accidental modifications that could affect project dependencies and settings.

## Getting Started

To create a new Oyda project, ensure you have Dart installed and run the following command:

```bash
oyda create --name <project_name> --host <host> --port <port> --oydaBase <database_name> --user <username> --password <password>
```

Make sure to replace `<project_name>`, `<host>`, `<port>`, `<database_name>`, `<username>`, and `<password>` with your specific project and database details.


## Requirements

* Dart SDK
* Flutter (optional, if you plan to use Flutter in your project)

For more information on how to install Dart and Flutter, visit the official Dart and Flutter documentation.


