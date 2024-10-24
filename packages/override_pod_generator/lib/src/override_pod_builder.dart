import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:override_pod_annotation/override_pod_annotation.dart';
import 'package:path/path.dart';
import 'package:source_gen/source_gen.dart';

class OverridePodsBuilder implements Builder {
  const OverridePodsBuilder(this._config);

  static const _defaultInput = 'lib/**.dart';
  static const _defaultOutput = 'override_pod.gen.dart';

  final Map<String, dynamic> _config;
  String get _output => _config['output_file'] as String? ?? _defaultOutput;

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      r'$lib$': [_output],
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final input = _config['input_file'] as String? ?? _defaultInput;
    final annotation = _config['annotation_class'] as String?;
    final valueName = _config['output_value_name'] as String? ??
        '${buildStep.inputId.package}PodOverrides';

    final assets = buildStep.findAssets(Glob(input));
    final allOverrides = <Expression>[];

    await for (final asset in assets) {
      if (!await buildStep.resolver.isLibrary(asset)) {
        continue;
      }

      final library = await buildStep.resolver.libraryFor(asset);
      final typeChecker = annotation != null
          ? TypeChecker.fromUrl(annotation)
          : const TypeChecker.fromRuntime(OverridePod);
      final libraryOverrides =
          LibraryReader(library).annotatedWith(typeChecker).map((annotated) {
        return refer(
          annotated.element.displayName,
          annotated.element.librarySource?.uri.toString(),
        );
      });

      allOverrides.addAll(libraryOverrides);
    }

    const reference = Reference('Override', 'package:riverpod/riverpod.dart');
    final podOverridesField = declareFinal(valueName)
        .assign(literalList(allOverrides, reference))
        .statement;

    final overrideLibrary = Library(
      (b) => b..body.add(podOverridesField),
    );

    final emitter = DartEmitter.scoped(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    final content = '''
$defaultFileHeader

${overrideLibrary.accept(emitter)}
''';

    await buildStep.writeAsString(
      AssetId(
        buildStep.inputId.package,
        join('lib', _output),
      ),
      DartFormatter().format(content),
    );
  }
}
