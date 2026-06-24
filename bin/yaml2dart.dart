import 'dart:io';
import 'package:yaml2dart/yaml2dart.dart';

void main(List<String> args) async {
  if (args.length != 2) {
    stderr.writeln('Usage: dart run yaml2dart <input.yaml> <output.dart>');
    exit(1);
  }

  final inputFilePath = args[0];
  final outputFilePath = args[1];

  final inputFile = File(inputFilePath);
  if (!await inputFile.exists()) {
    stderr.writeln('Error: Input file "$inputFilePath" does not exist.');
    exit(1);
  }

  final converter = Yaml2Dart(inputFilePath, outputFilePath);

  try {
    await converter.convert();
    stdout.writeln('Successfully generated "$outputFilePath" from "$inputFilePath".');
  } catch (e) {
    stderr.writeln('Error: $e');
    exit(1);
  }
}
