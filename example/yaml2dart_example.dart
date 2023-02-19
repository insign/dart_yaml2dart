import 'package:yaml2dart/yaml2dart.dart';

void main() async {
  // Create a converter instance with the input and output file paths.
  final converter = Yaml2Dart('example.yaml', 'example_constants.dart');

  // Convert the YAML to Dart.
  await converter.convert();
}
