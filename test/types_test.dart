import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'package:yaml2dart/yaml2dart.dart';

void main() {
  test('Converts YAML types to Dart constants correctly', () async {
    // Create a temporary directory for testing.
    final tempDir = await Directory.systemTemp.createTemp('yaml2dart_types_test_');
    final inputPath = path.join(tempDir.path, 'types_input.yaml');
    final outputPath = path.join(tempDir.path, 'types_output.dart');

    try {
      // Write the input YAML file.
      final inputFile = File(inputPath);
      await inputFile.writeAsString('''
stringValue: "Hello World"
intValue: 123
doubleValue: 12.34
boolValue: true
listValue:
  - 1
  - "two"
  - 3.0
mapValue:
  key1: value1
  key2: 2
nestedValue:
  nestedList: [1, 2]
  nestedMap:
    innerKey: innerValue
''');

      // Convert the YAML file to a Dart file.
      final converter = Yaml2Dart(inputPath, outputPath);
      await converter.convert();

      // Verify that the output Dart file exists and has the correct contents.
      final outputFile = File(outputPath);
      expect(await outputFile.exists(), isTrue);

      final content = await outputFile.readAsString();

      // Expected strings in the output
      expect(content, contains("const stringValue = 'Hello World';"));
      expect(content, contains("const intValue = 123;"));
      expect(content, contains("const doubleValue = 12.34;"));
      expect(content, contains("const boolValue = true;"));

      // Lists and Maps might have slight spacing differences, so we check structurally or key parts
      // But let's try to match exactly what we expect from the implementation
      // Assuming: const listValue = const [1, 'two', 3.0];
      expect(content, contains("const listValue = const [1, 'two', 3.0];"));

      // Assuming: const mapValue = const {'key1': 'value1', 'key2': 2};
      expect(content, contains("const mapValue = const {'key1': 'value1', 'key2': 2};"));

      // Nested
      // const nestedValue = const {'nestedList': const [1, 2], 'nestedMap': const {'innerKey': 'innerValue'}};
      expect(content, contains("const nestedValue = const {'nestedList': const [1, 2], 'nestedMap': const {'innerKey': 'innerValue'}};"));

    } finally {
      // Clean up the temporary directory.
      await tempDir.delete(recursive: true);
    }
  });
}
