import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wasla/app/shared/common/bloc_observer.dart';
import 'package:wasla/app/shared/common/common_libs.dart';
import 'package:wasla/data/network/api_service_client.dart';
import 'package:wasla/data/network/dio_factory.dart';
import 'package:wasla/data/repositories/auth_repository_impl.dart';
import 'package:wasla/domain/usecases/auth_usecases/login_usecase.dart';
import 'package:wasla/presentation/common/cubits/bear_cubit/bear_animation_cubit.dart';
import 'package:wasla/presentation/common/cubits/bear_dialog_cubit/bear_dialog_cubit.dart';
import 'package:wasla/presentation/common/cubits/password_icon_cubit/password_icon_cubit.dart';
import 'package:wasla/presentation/common/rive_controller.dart';
import 'package:wasla/presentation/modules/register/cubit/username_valdiator/username_validation_cubit.dart';

final GetIt getIt = GetIt.instance;

final class DIModulesManger {
  static Future<void> prepareAppModule() async {
    //bloc
    if (kDebugMode) {
      getIt.registerLazySingleton<MyBlocObserver>(() => MyBlocObserver());
    }

    //shared preferences
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

    //app preferences
    getIt.registerLazySingleton<AppPreferences>(
        () => AppPreferences(sharedPreferences: getIt<SharedPreferences>()));

    //network checker
    getIt.registerLazySingleton<NetworkChecker>(() =>
        NetworkCheckerImpl(connectionChecker: InternetConnectionChecker()));

    //dio factory
    final Dio dio = Dio();
    getIt.registerLazySingleton<Dio>(() => dio);
    getIt.registerLazySingleton<DioFactory>(() => DioFactory(
          appPreferences: getIt<AppPreferences>(),
          dio: getIt<Dio>(),
        ));

    // api service client
    final Dio getDio = await getIt<DioFactory>().getDio();
    getIt.registerLazySingleton<ApiServiceClient>(
        () => ApiServiceClient(getDio));

    //remote data source
    getIt.registerLazySingleton<RemoteDataSource>(() =>
        RemoteDataSourceImpl(apiServiceClient: getIt<ApiServiceClient>()));

    //repository
  }

  static void _registerFactory<TYPE extends Object>(TYPE object) {
    if (!GetIt.I.isRegistered<TYPE>()) {
      getIt.registerFactory<TYPE>(() => object);

      PrintManager.print("${object.toString()} is registered factory",
          color: ConsoleColor.brightBlack);
    }
  }

  static void prepareOnboardingModule() {
    _registerFactory<OnboardingCubit>(OnboardingCubit());
    _registerFactory<OnChangeOnBoardingPageCubit>(
        OnChangeOnBoardingPageCubit());
  }

  static void _prepareAuthModule() {
    _registerFactory<AuthRepository>(AuthRepositoryImpl(
      remoteDataSource: getIt<RemoteDataSource>(),
      networkChecker: getIt<NetworkChecker>(),
    ));

    ///ui
    _registerFactory<RiveControllerManager>(RiveControllerManager());
    //cubits used on auth
    _registerFactory<BearAnimationCubit>(
        BearAnimationCubit(getIt<RiveControllerManager>()));
    _registerFactory<BearDialogCubit>(BearDialogCubit());
    _registerFactory<PasswordIconCubit>(PasswordIconCubit());
  }

  static void prepareLoginModule() {
    _prepareAuthModule();

    ///use case
    _registerFactory<LoginUseCase>(
        LoginUseCase(repository: getIt<AuthRepository>()));

    ///cubit
    _registerFactory<LoginCubit>(LoginCubit(getIt<LoginUseCase>()));
  }

  static void prepareRegisterModule() {
    _prepareAuthModule();

    ///use case
    _registerFactory<LoginUseCase>(
        LoginUseCase(repository: getIt<AuthRepository>()));

    ///cubit
    _registerFactory<LoginCubit>(LoginCubit(getIt<LoginUseCase>()));
    _registerFactory<UsernameValidatorCubit>(UsernameValidatorCubit());
  }
}
