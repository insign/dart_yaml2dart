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
''');

      // Convert the YAML file to a Dart file.
      final converter = Yaml2Dart(inputPath, outputPath);
      await converter.convert();

      // Verify that the output Dart file exists and has the correct contents.
      final outputFile = File(outputPath);
      expect(await outputFile.exists(), isTrue);
      expect(await outputFile.readAsString(), equals('''
${converter.warning}
const title = 'My App';
const version = '1.2.3';
const author = 'John Doe';
'''));
    } finally {
      // Clean up the temporary directory.
      await tempDir.delete(recursive: true);
    }
  });

  test('Converts mixed YAML types to typed Dart constants', () async {
    final tempDir =
        await Directory.systemTemp.createTemp('yaml2dart_types_test_');
    final inputPath = path.join(tempDir.path, 'types_input.yaml');
    final outputPath = path.join(tempDir.path, 'types_output.dart');

    try {
      final inputFile = File(inputPath);
      await inputFile.writeAsString('''
        count: 42
        ratio: 3.14
        isEnabled: true
        items:
          - fast
          - reliable
        config:
          debug: false
          timeout: 100
        strWithQuote: "it's"
        strWithBackslash: 'a\\b'
        price: "Cost: \$10"
''');

      final converter = Yaml2Dart(inputPath, outputPath);
      await converter.convert();

      final outputFile = File(outputPath);
      expect(await outputFile.exists(), isTrue);
      final content = await outputFile.readAsString();

      // Verify typed constants
      expect(content, contains('const count = 42;'));
      expect(content, contains('const ratio = 3.14;'));
      expect(content, contains('const isEnabled = true;'));
      expect(content, contains('const items = ["fast","reliable"];'));
      expect(
          content, contains('const config = {"debug":false,"timeout":100};'));
      expect(content, contains(r"const strWithQuote = 'it\'s';"));
      expect(content, contains(r"const strWithBackslash = 'a\\b';"));
      // Verify $ escaping
      expect(content, contains(r"const price = 'Cost: \$10';"));
    } finally {
      await tempDir.delete(recursive: true);
    }
  });
}
