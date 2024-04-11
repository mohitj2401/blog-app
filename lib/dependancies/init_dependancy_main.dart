part of 'package:blog_app/dependancies/init_dependancies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependancies() async {
  _initAuth();
  _initBlog();

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  final supabase = await Supabase.initialize(
      url: AppSecret.supbaseUrl, anonKey: AppSecret.apiKey);
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImp(serviceLocator()));
}

Future<void> _initAuth() async {
  serviceLocator.registerFactory<AuthDataSource>(
      () => AuthDataSourceImp(serviceLocator()));

  serviceLocator.registerFactory<AuthRepository>(
      () => AuthRepositoryImp(serviceLocator(), serviceLocator()));

  serviceLocator.registerFactory(() => UserSignUp(serviceLocator()));

  serviceLocator.registerFactory(() => UserSignIn(serviceLocator()));

  serviceLocator.registerFactory(() => CurrentUser(serviceLocator()));

  serviceLocator.registerFactory(() => SignOutUser(serviceLocator()));

  serviceLocator.registerLazySingleton(() => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        currentUser: serviceLocator(),
        signOutUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ));
}

Future<void> _initBlog() async {
  serviceLocator.registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImp(serviceLocator()));

  serviceLocator.registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImp(serviceLocator()));

  serviceLocator.registerFactory<BlogRepository>(() => BlogRepositoryImp(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => UploadBlog(serviceLocator()));
  serviceLocator.registerFactory(() => GetBlogs(serviceLocator()));

  serviceLocator.registerFactory(() => EditBlog(serviceLocator()));

  serviceLocator.registerFactory(() => DeleteBlogCase(serviceLocator()));

  serviceLocator.registerLazySingleton(() => BlogBloc(
        uploadBlog: serviceLocator(),
        getBlogs: serviceLocator(),
        editBlog: serviceLocator(),
        deleteBlog: serviceLocator(),
        appUserCubit: serviceLocator(),
      ));
}
