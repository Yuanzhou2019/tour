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

import '../../features/feedback/data/repositories/feedback_repository_impl.dart'
    as _i4;
import '../../features/feedback/domain/repositories/feedback_repository.dart'
    as _i5;
import '../../features/feedback/presentation/cubit/feedback_form_cubit.dart'
    as _i6;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i1;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i2;
import '../../features/onboarding/presentation/cubit/first_run_settings_cubit.dart'
    as _i3;
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
    gh.lazySingleton<_i4.FeedbackRepositoryImpl>(
        () => _i4.FeedbackRepositoryImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i5.FeedbackRepository>(
        () => gh<_i4.FeedbackRepositoryImpl>());
    gh.factory<_i6.FeedbackFormCubit>(
        () => _i6.FeedbackFormCubit(gh<_i5.FeedbackRepository>()));
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
    return this;
  }
}
