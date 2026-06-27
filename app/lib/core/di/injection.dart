import 'package:get_it/get_it.dart';

/// Global service locator. See [Architecture Spec §3.5].
final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // TODO(stage-1): register blocs, repositories, datasources, services
  // TODO(stage-1): @injectableInit will replace this with generated config
}
