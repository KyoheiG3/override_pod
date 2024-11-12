# override_pod

The `override_pod` package is a tool for generating `Override` variables for riverpod. This package uses annotations to automatically aggregate defined `Override` variables into a single array, variableize them, and output them to a generated file.

## Overview

When overriding riverpod's `Provider`, you need to set `Override` variables to override the `Provider` in the `overrides` property of `ProviderScope`. If you override many `Providers`, it can be cumbersome to set many variables, but using `override_pod` can alleviate that hassle.

### Before

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
    runApp(
        ProviderScope(
            overrides: [
                fooProvider.overrideWith(FooProviderImpl.new),
                barProvider.overrideWith(BarProviderImpl.new),
                bazProvider.overrideWith(BazProviderImpl.new),
                quxProvider.overrideWith(QuxProviderImpl.new),
                quuxProvider.overrideWith(QuuxProviderImpl.new),
                corgeProvider.overrideWith(CorgeProviderImpl.new),
                graultProvider.overrideWith(GraultProviderImpl.new),
            ],
            child: const MyApp(),
        ),
    );
}
```

### After

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
    runApp(
        ProviderScope(
            overrides: packagePodOverrides,
            child: const MyApp(),
        ),
    );
}
```

Super cool!

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  override_pod_annotation:

dev_dependencies:
  override_pod_generator:
  build_runner:
```

## Usage

1. Define variables using annotations. For example, in `lib/src/repository/foo.dart`:

```dart
import 'package:override_pod_annotation/override_pod_annotation.dart';

@overridePod
final pod = fooRepositoryProvider.overrideWith(FooRepositoryImpl.new);

class FooRepositoryImpl implements FooRepository {
    const FooRepositoryImpl(this.ref);
    final FooRepositoryRef ref;
}
```

2. Generate code using `build_runner`:

```sh
$ flutter pub run build_runner build
```

3. Use the generated code to override pods. For example, in `lib/main.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
    runApp(
        ProviderScope(
            overrides: packagePodOverrides,
            child: const MyApp(),
        ),
    );
}
```

## Options

You can configure options in `build.yaml`.

```yaml
targets:
  $default:
    builders:
      override_pod_generator:
        options:
          input_file: lib/repository/**.dart
          output_file: pods.gen.dart
          output_value_name: pods
          annotation_class: package:override_pod_generator/src/annotation.dart#Pods
```

#### `input_file`

- Specifies the path of the input file.
- The default is `lib/**.dart`.

#### `output_file`

- Specifies the path of the output file.
- The default is `lib/override_pod.gen.dart`.

#### `output_value_name`

- Specifies the variable name output to the output file.
- The default is `${package_name}PodOverrides`.

#### `annotation_class`

- Specifies the annotation class.
- The default is `OverridePod`.

## License

`override_pod` is released under the [BSD-3-Clause License](./LICENSE).
