import 'dart:io';
import 'package:yaml2dart/yaml2dart.dart';

void main(List<String> args) async {
  if (args.length != 2) {
    print('Usage: dart run yaml2dart <input.yaml> <output.dart>');
    exit(1);
  }

  final inputFilePath = args[0];
  final outputFilePath = args[1];

  try {
    final converter = Yaml2Dart(inputFilePath, outputFilePath);
    await converter.convert();
    print('Successfully converted $inputFilePath to $outputFilePath');
  } catch (e) {
    print('Error converting YAML to Dart: $e');
    exit(1);
  }
}
