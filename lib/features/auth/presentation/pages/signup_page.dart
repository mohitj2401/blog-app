import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  void dispose() {
    emailTextEditingController.dispose();
    nameTextEditingController.dispose();
    passwordTextEditingController.dispose();

    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          }
          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          }
          if (state is AuthSignOutSuccess) {
            Navigator.pushAndRemoveUntil(
                context, SignInPage.route(), (route) => false);
          }

          if (state is AuthLoading) {
            EasyLoading.show(maskType: EasyLoadingMaskType.clear);
          } else {
            EasyLoading.dismiss();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 50),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AuthField(
                        hintText: "Name",
                        controller: nameTextEditingController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthField(
                          hintText: "Email",
                          controller: emailTextEditingController),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthField(
                        hintText: "Password",
                        controller: passwordTextEditingController,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthGradientButton(
                        buttonText: "Sign Up",
                        onPressed: () => {
                          if (formKey.currentState!.validate())
                            {
                              context.read<AuthBloc>().add(AuthSignUp(
                                    name: nameTextEditingController.text.trim(),
                                    email:
                                        emailTextEditingController.text.trim(),
                                    password: passwordTextEditingController.text
                                        .trim(),
                                  ))
                            }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, SignInPage.route());
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account?",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: " Sign In",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppPallete.gradient2,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
