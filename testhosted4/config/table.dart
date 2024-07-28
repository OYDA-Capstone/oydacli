import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oydadb/src/oyda_interface.dart';

void main() async {
  await dotenv.load(fileName: '.env');
// Create a new table in the OydaBase
// Replace test_table with the name of the table you want to create in your oydabase
  await OydaInterface().createTable('test_table', {'name': 'VARCHAR(255)', 'age': 'INTEGER'});

// Drop an existing table from the OydaBase
// Replace test_table with the name of the table you want to drop
  await OydaInterface().dropTable('test_table');
}
