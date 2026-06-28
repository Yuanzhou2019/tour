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
    as _i4;
import '../../features/discover/domain/repositories/discover_repository.dart'
    as _i5;
import '../../features/discover/presentation/cubit/discover_home_cubit.dart'
    as _i6;
import '../../features/feedback/data/repositories/feedback_repository_impl.dart'
    as _i7;
import '../../features/feedback/domain/repositories/feedback_repository.dart'
    as _i8;
import '../../features/feedback/presentation/cubit/feedback_form_cubit.dart'
    as _i9;
import '../../features/map/data/repositories/poi_repository_impl.dart'
    as _i10;
import '../../features/map/domain/repositories/poi_repository.dart' as _i11;
import '../../features/map/presentation/cubit/map_home_cubit.dart' as _i12;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i1;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i2;
import '../../features/onboarding/presentation/cubit/first_run_settings_cubit.dart'
    as _i3;
import '../../features/prepare/data/repositories/checklist_repository_impl.dart'
    as _i13;
import '../../features/prepare/data/repositories/policy_repository_impl.dart'
    as _i14;
import '../../features/prepare/domain/repositories/checklist_repository.dart'
    as _i15;
import '../../features/prepare/domain/repositories/policy_repository.dart'
    as _i16;
import '../../features/prepare/presentation/cubit/prepare_home_cubit.dart'
    as _i17;
import '../../features/tools/data/repositories/fx_repository_impl.dart'
    as _i18;
import '../../features/tools/data/repositories/tools_repository_impl.dart'
    as _i19;
import '../../features/tools/domain/repositories/fx_repository.dart' as _i20;
import '../../features/tools/domain/repositories/tools_repository.dart'
    as _i21;
import '../../features/tools/presentation/cubit/fx_converter_cubit.dart'
    as _i22;
import '../../features/tools/presentation/cubit/tools_home_cubit.dart'
    as _i23;
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
    gh.lazySingleton<_i1.OnboardingRepositoryImpl>(
        () => _i1.OnboardingRepositoryImpl());
    gh.lazySingleton<_i2.OnboardingRepository>(
        () => gh<_i1.OnboardingRepositoryImpl>());
    gh.lazySingleton<_i3.FirstRunSettingsCubit>(
        () => _i3.FirstRunSettingsCubit());
    gh.lazySingleton<_i7.FeedbackRepositoryImpl>(
        () => _i7.FeedbackRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i8.FeedbackRepository>(
        () => gh<_i7.FeedbackRepositoryImpl>());
    gh.factory<_i9.FeedbackFormCubit>(
        () => _i9.FeedbackFormCubit(gh<_i8.FeedbackRepository>()));
    gh.lazySingleton<_i734.LocaleCubit>(() => _i734.LocaleCubit());
    gh.lazySingleton<_i745.AuthInterceptor>(() => _i745.AuthInterceptor());
    gh.lazySingleton<_i511.ErrorInterceptor>(() => _i511.ErrorInterceptor());
    gh.lazySingleton<_i344.LoggingInterceptor>(
        () => _i344.LoggingInterceptor());
    gh.lazySingleton<_i392.MockInterceptor>(() => _i392.MockInterceptor());
    gh.lazySingleton<_i914.RetryInterceptor>(() => _i914.RetryInterceptor());
    gh.lazySingleton<_i611.ThemeCubit>(() => _i611.ThemeCubit());
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient(
          gh<_i745.AuthInterceptor>(),
          gh<_i344.LoggingInterceptor>(),
          gh<_i511.ErrorInterceptor>(),
          gh<_i392.MockInterceptor>(),
          gh<_i914.RetryInterceptor>(),
        ));
    gh.lazySingleton<_i14.PolicyRepositoryImpl>(
        () => _i14.PolicyRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i16.PolicyRepository>(
        () => gh<_i14.PolicyRepositoryImpl>());
    gh.lazySingleton<_i13.ChecklistRepositoryImpl>(
        () => _i13.ChecklistRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i15.ChecklistRepository>(
        () => gh<_i13.ChecklistRepositoryImpl>());
    gh.lazySingleton<_i10.PoiRepositoryImpl>(
        () => _i10.PoiRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i11.PoiRepository>(() => gh<_i10.PoiRepositoryImpl>());
    gh.lazySingleton<_i4.DiscoverRepositoryImpl>(
        () => _i4.DiscoverRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i5.DiscoverRepository>(
        () => gh<_i4.DiscoverRepositoryImpl>());
    gh.lazySingleton<_i18.FxRepositoryImpl>(
        () => _i18.FxRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i20.FxRepository>(() => gh<_i18.FxRepositoryImpl>());
    gh.lazySingleton<_i19.ToolsRepositoryImpl>(
        () => _i19.ToolsRepositoryImpl());
    gh.lazySingleton<_i21.ToolsRepository>(
        () => gh<_i19.ToolsRepositoryImpl>());
    gh.factory<_i17.PrepareHomeCubit>(() => _i17.PrepareHomeCubit(
          gh<_i16.PolicyRepository>(),
          gh<_i15.ChecklistRepository>(),
        ));
    gh.factory<_i12.MapHomeCubit>(
        () => _i12.MapHomeCubit(gh<_i11.PoiRepository>()));
    gh.factory<_i6.DiscoverHomeCubit>(
        () => _i6.DiscoverHomeCubit(gh<_i5.DiscoverRepository>()));
    gh.factory<_i23.ToolsHomeCubit>(
        () => _i23.ToolsHomeCubit(gh<_i21.ToolsRepository>()));
    gh.factory<_i22.FxConverterCubit>(
        () => _i22.FxConverterCubit(gh<_i20.FxRepository>()));
    return this;
  }
}