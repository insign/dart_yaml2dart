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
        build: 100
        enabled: true
        pi: 3.14
        features: ["dark_mode", "beta"]
        config: {timeout: 3000}
''');

      // Convert the YAML file to a Dart file.
      final converter = Yaml2Dart(inputPath, outputPath);
      await converter.convert();

      // Verify that the output Dart file exists and has the correct contents.
      final outputFile = File(outputPath);
      expect(await outputFile.exists(), isTrue);
      // jsonEncode produces double quotes for strings and standard JSON format for lists/maps.
      expect(await outputFile.readAsString(), equals('''
${converter.warning}
const title = "My App";
const version = "1.2.3";
const author = "John Doe";
const build = 100;
const enabled = true;
const pi = 3.14;
const features = ["dark_mode","beta"];
const config = {"timeout":3000};
'''));
    } finally {
      // Clean up the temporary directory.
      await tempDir.delete(recursive: true);
    }
  });
}
