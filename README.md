# yaml2dart

Converts a YAML file to a Dart file containing global scope constants. It allows developers to easily use YAML data in their Dart projects by generating a separate file with all the YAML data as constants. Especially good for `pubspec.yaml`.

## Getting started

```dart
dart pub add yaml2dart
```

## Usage

Assuming that the `example.yaml` file contains the following:

```yaml
name: "My Project"
version: "1.0.0"
```

The code is:

```dart
import 'package:yaml2dart/yaml2dart.dart';

void main() async {
  // Create a converter instance with the input and output file paths.
  final converter = Yaml2Dart('pub.yaml', 'lib/example_constants.dart');

  // Convert the YAML to Dart.
  await converter.convert();
}
```

The `example_constants.dart` file will be generated with the following content:

```dart
const exampleName = 'My Project';
const exampleVersion = '1.0.0';
```

To test:

```dart
  // Use the generated constants in your project.
  import 'package:my_project/example_constants.dart';

  print('Example name: $exampleName');
  print('Example version: $exampleVersion');
```

## LICENSE

[BSD 3-Clause License](./LICENSE)

## CONTRIBUTE

If you have an idea for a new feature or have found a bug, just do a pull request (PR).
