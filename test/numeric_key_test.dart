import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'package:yaml2dart/yaml2dart.dart';

void main() {
  test('Converts YAML with numeric keys', () async {
    final tempDir = await Directory.systemTemp.createTemp('yaml2dart_numeric_');
    final inputPath = path.join(tempDir.path, 'numeric_input.yaml');
    final outputPath = path.join(tempDir.path, 'numeric_output.dart');

    try {
      final inputFile = File(inputPath);
      await inputFile.writeAsString("1: one");

      final converter = Yaml2Dart(inputPath, outputPath);
      await converter.convert();

      final outputFile = File(outputPath);
      expect(await outputFile.readAsString(), equals('''
${converter.warning}
const 1 = "one";
'''));
    } finally {
      await tempDir.delete(recursive: true);
    }
  });
}
