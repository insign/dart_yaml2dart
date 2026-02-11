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
const title = "My App";
const version = "1.2.3";
const author = "John Doe";
'''));
    } finally {
      // Clean up the temporary directory.
      await tempDir.delete(recursive: true);
    }
  });

  test('Converts YAML with types and escaping', () async {
    final tempDir = await Directory.systemTemp.createTemp('yaml2dart_test_types_');
    final inputPath = path.join(tempDir.path, 'test_input.yaml');
    final outputPath = path.join(tempDir.path, 'test_output.dart');

    try {
      final inputFile = File(inputPath);
      await inputFile.writeAsString('''
title: "My App's Name"
version: 1.0
build: 10
enabled: true
list: [1, 2]
map: {a: 1}
123: "numeric key"
''');

      final converter = Yaml2Dart(inputPath, outputPath);
      await converter.convert();

      final outputFile = File(outputPath);
      expect(await outputFile.exists(), isTrue);
      final content = await outputFile.readAsString();

      // Check for expected output with types
      expect(content, contains('const title = "My App\'s Name";'));
      expect(content, contains('const version = 1.0;'));
      expect(content, contains('const build = 10;'));
      expect(content, contains('const enabled = true;'));
      expect(content, contains('const list = [1,2];'));
      expect(content, contains('const map = {"a":1};'));
      // Verify numeric key handling (converted to string key internally for ReCase)
      expect(content, contains('const 123 = "numeric key";'));

    } finally {
      await tempDir.delete(recursive: true);
    }
  });
}
