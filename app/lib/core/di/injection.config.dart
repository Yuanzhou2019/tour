// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/discover/data/repositories/discover_repository_impl.dart'
    as _i76;
import '../../features/discover/domain/repositories/discover_repository.dart'
    as _i302;
import '../../features/discover/presentation/cubit/discover_home_cubit.dart'
    as _i1025;
import '../../features/feedback/data/repositories/feedback_repository_impl.dart'
    as _i961;
import '../../features/feedback/domain/repositories/feedback_repository.dart'
    as _i619;
import '../../features/feedback/presentation/cubit/feedback_form_cubit.dart'
    as _i795;
import '../../features/map/data/repositories/poi_repository_impl.dart' as _i404;
import '../../features/map/domain/repositories/poi_repository.dart' as _i170;
import '../../features/map/presentation/cubit/map_home_cubit.dart' as _i710;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i452;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i430;
import '../../features/onboarding/presentation/cubit/first_run_settings_cubit.dart'
    as _i23;
import '../../features/prepare/data/repositories/checklist_repository_impl.dart'
    as _i882;
import '../../features/prepare/data/repositories/policy_repository_impl.dart'
    as _i508;
import '../../features/prepare/domain/repositories/checklist_repository.dart'
    as _i909;
import '../../features/prepare/domain/repositories/policy_repository.dart'
    as _i904;
import '../../features/prepare/presentation/cubit/prepare_home_cubit.dart'
    as _i244;
import '../../features/tools/data/repositories/fx_repository_impl.dart'
    as _i937;
import '../../features/tools/data/repositories/tools_repository_impl.dart'
    as _i438;
import '../../features/tools/domain/repositories/fx_repository.dart' as _i457;
import '../../features/tools/domain/repositories/tools_repository.dart'
    as _i590;
import '../../features/tools/presentation/cubit/fx_converter_cubit.dart'
      as _i516;
  import '../../features/tools/presentation/cubit/tools_home_cubit.dart' as _i318;
  import '../../features/poi/data/repositories/poi_repository_impl.dart' as _i1060;
  import '../../features/poi/domain/repositories/poi_repository.dart' as _i1061;
  import '../../features/poi/presentation/cubit/poi_detail_cubit.dart' as _i1062;
  import '../../features/emergency/data/repositories/emergency_repository_impl.dart'
      as _i1063;
  import '../../features/emergency/domain/repositories/emergency_repository.dart'
      as _i1064;
  import '../../features/phrases/data/repositories/phrases_repository_impl.dart'
      as _i1065;
  import '../../features/phrases/domain/repositories/phrases_repository.dart'
      as _i1066;
  import '../i18n/locale_cubit.dart' as _i734;
import '../network/dio_client.dart' as _i667;
import '../network/interceptors/auth_interceptor.dart' as _i745;
import '../network/interceptors/error_interceptor.dart' as _i511;
import '../network/interceptors/logging_interceptor.dart' as _i344;
import '../network/interceptors/mock_interceptor.dart' as _i392;
import '../network/interceptors/retry_interceptor.dart' as _i914;
import '../theme/theme_cubit.dart' as _i611;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i734.LocaleCubit>(() => _i734.LocaleCubit());
    gh.lazySingleton<_i745.AuthInterceptor>(() => _i745.AuthInterceptor());
    gh.lazySingleton<_i511.ErrorInterceptor>(() => _i511.ErrorInterceptor());
    gh.lazySingleton<_i344.LoggingInterceptor>(
        () => _i344.LoggingInterceptor());
    gh.lazySingleton<_i392.MockInterceptor>(() => _i392.MockInterceptor());
    gh.lazySingleton<_i914.RetryInterceptor>(() => _i914.RetryInterceptor());
    gh.lazySingleton<_i611.ThemeCubit>(() => _i611.ThemeCubit());
    gh.lazySingleton<_i23.FirstRunSettingsCubit>(
        () => _i23.FirstRunSettingsCubit());
    gh.lazySingleton<_i590.ToolsRepository>(() => _i438.ToolsRepositoryImpl());
    gh.lazySingleton<_i430.OnboardingRepository>(
        () => _i452.OnboardingRepositoryImpl());
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient(
          gh<_i745.AuthInterceptor>(),
          gh<_i344.LoggingInterceptor>(),
          gh<_i511.ErrorInterceptor>(),
          gh<_i392.MockInterceptor>(),
          gh<_i914.RetryInterceptor>(),
        ));
    gh.lazySingleton<_i904.PolicyRepository>(
        () => _i508.PolicyRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i909.ChecklistRepository>(
        () => _i882.ChecklistRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i170.PoiRepository>(
        () => _i404.PoiRepositoryImpl(gh<_i667.DioClient>()));
    gh.factory<_i318.ToolsHomeCubit>(
        () => _i318.ToolsHomeCubit(gh<_i590.ToolsRepository>()));
    gh.lazySingleton<_i302.DiscoverRepository>(
        () => _i76.DiscoverRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i457.FxRepository>(
        () => _i937.FxRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i619.FeedbackRepository>(
        () => _i961.FeedbackRepositoryImpl(gh<_i667.DioClient>()));
    gh.factory<_i244.PrepareHomeCubit>(() => _i244.PrepareHomeCubit(
          gh<_i904.PolicyRepository>(),
          gh<_i909.ChecklistRepository>(),
        ));
    gh.factory<_i795.FeedbackFormCubit>(
        () => _i795.FeedbackFormCubit(gh<_i619.FeedbackRepository>()));
    gh.factory<_i516.FxConverterCubit>(
        () => _i516.FxConverterCubit(gh<_i457.FxRepository>()));
    gh.factory<_i710.MapHomeCubit>(
        () => _i710.MapHomeCubit(gh<_i170.PoiRepository>()));
    gh.factory<_i1025.DiscoverHomeCubit>(
        () => _i1025.DiscoverHomeCubit(gh<_i302.DiscoverRepository>()));
    gh.lazySingleton<_i1061.PoiRepository>(
        () => _i1060.PoiRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i1064.EmergencyRepository>(
        () => _i1063.EmergencyRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i1066.PhrasesRepository>(
        () => _i1065.PhrasesRepositoryImpl(gh<_i667.DioClient>()));
    gh.factory<_i1062.PoiDetailCubit>(
        () => _i1062.PoiDetailCubit(gh<_i1061.PoiRepository>()));
    return this;
  }
}
