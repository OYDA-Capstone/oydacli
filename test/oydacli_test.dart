import 'dart:io';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:oydacli/create.dart';

// Create a mock class for the setOydabase function
class MockOydaInterface extends Mock {
  Future<bool> setOydabase(String host, int port, String oydaBase, String user, String password);
}

void main() {
  group('createProject', () {
    final String projectDir =
        '/Users/admin/Library/CloudStorage/OneDrive-AshesiUniversity/Ashesi University/ashesi_year_4/capstone/OYDA-Capstone/test_project';
    Directory testDir = Directory(projectDir);
    final String host = 'localhost';
    final int port = 5432;
    final String oydaBase = 'oyda_db';
    final String user = 'oydaadmin';
    final String password = 'none';

    test('create project', () async {
      await createProject(projectDir, host, port, oydaBase, user, password);

      // Verify the project directory and files are created
      expect(testDir.existsSync(), isTrue);
      expect(File(path.join(projectDir, 'lib', 'main.dart')).existsSync(), isTrue);
      expect(File(path.join(projectDir, 'test', 'widget_test.dart')).existsSync(), isTrue);
      expect(File(path.join(projectDir, 'README.md')).existsSync(), isTrue);
      expect(File(path.join(projectDir, '.env')).existsSync(), isTrue);
      final pubspecFile = File(path.join(projectDir, 'pubspec.yaml'));
      expect(pubspecFile.existsSync(), isTrue);

      // Verify the pubspec.yaml file is read-only
      final FileStat stat = pubspecFile.statSync();
      expect(stat.modeString(), contains('r--'));
    });
  });
}
