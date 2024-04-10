import 'package:blog_app/core/common/widgets/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/dependancies/init_dependancies.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependancies();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
      BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthBloc>().add(AuthLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: false,
      title: 'Blog App',
      theme: AppTheme.darkTheme,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isloggedIn) {
          if (isloggedIn) {
            return const BlogPage();
          } else {
            return const SignInPage();
          }
        },
        bloc: AppUserCubit(),
      ),
    );
  }
}
