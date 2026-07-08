import 'dart:io';
import 'package:yaml2dart/yaml2dart.dart';

void main(List<String> args) async {
  if (args.length != 2) {
    stderr.writeln('Usage: dart run yaml2dart <input.yaml> <output.dart>');
    exit(1);
  }

  final inputPath = args[0];
  final outputPath = args[1];

  final inputFile = File(inputPath);
  if (!await inputFile.exists()) {
    stderr.writeln('Error: Input file "$inputPath" does not exist.');
    exit(1);
  }

  try {
    final converter = Yaml2Dart(inputPath, outputPath);
    await converter.convert();
    print('Successfully converted $inputPath to $outputPath');
  } catch (e) {
    stderr.writeln('Error converting file: $e');
    exit(1);
  }
}
