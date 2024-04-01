import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/dependancies/init_dependancies.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependancies();

  runApp(MultiBlocProvider(
    providers: [BlocProvider(create: (_) => serviceLocator<AuthBloc>())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: false,
      title: 'Blog App',
      theme: AppTheme.darkTheme,
      home: const SignInPage(),
    );
  }
}
