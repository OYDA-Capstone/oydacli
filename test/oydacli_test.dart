import 'package:oydacli/utilities.dart';
import 'package:test/test.dart';
import 'package:oydacli/create.dart';

void main() {
  group('createProject', () {
    // final String projectDir ='../apptest/testhosted4';
    final String projectDir = 'testhosted4';
    final String host = 'oydaserver.postgres.database.azure.com';
    final int port = 5432;
    final String oydaBase = 'oydadb';
    final String user = 'oydaadmin';
    final String password = 'OhenebaOmar123';
    // final String host = 'localhost';
    // final int port = 5432;
    // final String oydaBase = 'oyda_db';
    // final String user = 'oydaadmin';
    // final String password = 'none';

    test('create project', () async {
      await createProject(projectDir, host, port, oydaBase, user, password);
    });

    test('run project', () async {
      runProject(projectDir);
    });

    test('fetch dependencies', () async {
      await fetchDependencies(projectDir);
    });

    test('add dependencies', () async {
      await addDependency(projectDir, "yaml_magic");
    });
  });
}
