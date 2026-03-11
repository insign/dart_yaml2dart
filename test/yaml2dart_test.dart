import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'package:yaml2dart/yaml2dart.dart';

void main() {
  test('Converts YAML to Dart constants', () async {
    // Create a temporary directory for testing.
    final tempDir = await Directory.systemTemp.createTemp('yaml2dart_test_');
    final inputPath = path.join(tempDir.path, 'test_input.yaml');
    final outputPath = path.join(tempDir.path, 'test_output.dart');

    try {
      // Write the input YAML file.
      final inputFile = File(inputPath);
      await inputFile.writeAsString('''
        title: My App
        version: 1.2.3
        author: John Doe
        price: "100\$"
        is_active: true
        count: 42
        data:
          key1: val1
        items:
          - 1
          - 2
''');

      // Convert the YAML file to a Dart file.
      final converter = Yaml2Dart(inputPath, outputPath);
      await converter.convert();

      // Verify that the output Dart file exists and has the correct contents.
      final outputFile = File(outputPath);
      expect(await outputFile.exists(), isTrue);
      expect(await outputFile.readAsString(), equals('''
${converter.warning}
const String title = 'My App';
const String version = '1.2.3';
const String author = 'John Doe';
const String price = '100\\\$';
const bool isActive = true;
const num count = 42;
const Map data = {"key1":"val1"};
const List items = [1,2];
'''));
    } finally {
      // Clean up the temporary directory.
      await tempDir.delete(recursive: true);
    }
  });
}
