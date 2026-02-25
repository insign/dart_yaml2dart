import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'package:yaml2dart/yaml2dart.dart';

void main() {
  test('Converts YAML with mixed types to Dart constants', () async {
    final tempDir = await Directory.systemTemp.createTemp('yaml2dart_mixed_');
    final inputPath = path.join(tempDir.path, 'mixed_input.yaml');
    final outputPath = path.join(tempDir.path, 'mixed_output.dart');

    try {
      final inputFile = File(inputPath);
      await inputFile.writeAsString('''
        name: My App
        version: 1
        isEnabled: true
        features:
          - feature1
          - feature2
        settings:
          theme: dark
          notifications: false
''');

      final converter = Yaml2Dart(inputPath, outputPath);
      await converter.convert();

      final outputFile = File(outputPath);
      expect(await outputFile.readAsString(), equals('''
${converter.warning}
const name = "My App";
const version = 1;
const isEnabled = true;
const features = ["feature1","feature2"];
const settings = {"theme":"dark","notifications":false};
'''));
    } finally {
      await tempDir.delete(recursive: true);
    }
  });
}
