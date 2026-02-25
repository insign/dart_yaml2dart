import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'package:yaml2dart/yaml2dart.dart';

void main() {
  test('Converts YAML with strings requiring escaping to Dart constants', () async {
    final tempDir = await Directory.systemTemp.createTemp('yaml2dart_escape_');
    final inputPath = path.join(tempDir.path, 'escape_input.yaml');
    final outputPath = path.join(tempDir.path, 'escape_output.dart');

    try {
      final inputFile = File(inputPath);
      await inputFile.writeAsString('''
        singleQuote: "It's me"
        doubleQuote: 'He said "Hello"'
        newline: "Line 1\\nLine 2"
''');

      final converter = Yaml2Dart(inputPath, outputPath);
      await converter.convert();

      final outputFile = File(outputPath);

      expect(await outputFile.readAsString(), equals('''
${converter.warning}
const singleQuote = "It's me";
const doubleQuote = "He said \\"Hello\\"";
const newline = "Line 1\\nLine 2";
'''));
    } finally {
      await tempDir.delete(recursive: true);
    }
  });
}
