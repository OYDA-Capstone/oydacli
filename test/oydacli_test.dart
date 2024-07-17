import 'package:oydacli/utilities.dart';
import 'package:test/test.dart';
import 'package:oydacli/create.dart';


void main() {
  group('createProject', () {
    final String projectDir ='../apptest/test_project_rn';
    // final String host = 'http://oydaserver.postgres.database.azure.com';
    // final int port = 5432;
    // final String oydaBase = 'oydadb';
    // final String user = 'oydaadmin';
    // final String password = 'OhenebaOmar123';
    final String host = 'localhost';
    final int port = 5432;
    final String oydaBase = 'oyda_db';
    final String user = 'oydaadmin';
    final String password = 'none';

    test('create project', () async {
      print('testing create project...');
      await createProject(projectDir, host, port, oydaBase, user, password);
    });

    test('fetch dependencies', () async {
      await fetchDependencies(projectDir);
    });

    test('add dependencies', () async {
      await addDependency("http");
    });
  });
}
