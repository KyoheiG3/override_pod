import 'package:build/build.dart';
import 'package:override_pod_generator/src/override_pod_builder.dart';

Builder overridePodsBuilder(BuilderOptions options) => OverridePodsBuilder(
      options.config,
    );
