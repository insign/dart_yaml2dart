import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:recase/recase.dart';

/// A utility class for converting YAML files to Dart constants.
class Yaml2Dart {
  final String inputFilePath;
  final String outputFilePath;

  /// Creates a new instance of the `Yaml2Dart` class.
  ///
  /// [inputFilePath] is the path to the input YAML file.
  /// [outputFilePath] is the path to the output Dart file.
  Yaml2Dart(this.inputFilePath, this.outputFilePath);

  /// Converts the input YAML file to a Dart file containing constants.
  Future<void> convert() async {
    // Read the YAML file.
    final file = File(inputFilePath);
    final contents = await file.readAsString();
    final yaml = loadYaml(contents);

    // Create the output Dart file.
    final output = File(outputFilePath);
    final buffer = StringBuffer();

    // Write each key-value pair in the YAML file as a Dart constant.
    yaml.forEach((key, value) {
      key = ReCase(key).camelCase;
      buffer.writeln('const $key = \'$value\';');
    });

    // Write the contents to the output file.
    await output.writeAsString(buffer.toString());
  }
}
