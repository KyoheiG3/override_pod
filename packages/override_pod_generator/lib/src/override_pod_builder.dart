import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:override_pod_annotation/override_pod_annotation.dart';
import 'package:path/path.dart';
import 'package:source_gen/source_gen.dart';

class OverridePodsBuilder implements Builder {
  static const _outputName = 'override_pod.gen.dart';

  @override
  Map<String, List<String>> get buildExtensions {
    return const {
      r'$lib$': [_outputName],
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final assets = buildStep.findAssets(Glob('lib/**/*.dart'));
    final allOverrides = <Expression>[];

    await for (final asset in assets) {
      if (!await buildStep.resolver.isLibrary(asset)) {
        continue;
      }

      final library = await buildStep.resolver.libraryFor(asset);
      final libraryOverrides = LibraryReader(library)
          .annotatedWith(const TypeChecker.fromRuntime(OverridePod))
          .map((annotated) {
        return refer(
          annotated.element.displayName,
          annotated.element.librarySource?.uri.toString(),
        );
      });

      allOverrides.addAll(libraryOverrides);
    }

    const reference = Reference('Override', 'package:riverpod/riverpod.dart');
    final podOverridesField =
        declareFinal('${buildStep.inputId.package}PodOverrides')
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
        join('lib', _outputName),
      ),
      DartFormatter().format(content),
    );
  }
}
