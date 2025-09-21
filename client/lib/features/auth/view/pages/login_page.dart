import 'package:client/core/uitils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custome_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  
  }

  @override
  Widget build(BuildContext context) {

  // final isLoading = ref.watch(authViewModelProvider.select((val) => val?.isLoading == true));
  // ref.listen(
  //   authViewModelProvider,
  //   (previous, next) {
  //     next?.when(
  //       data: (data) {
  //         // Only navigate if we are logging in
          
  //           Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const HomePage(),
  //             ),
  //             (_) => false,
  //           );
          
  //       },
  //       error: (error, st) {
  //         showSnackBar(context, error.toString());
  //       },
  //       loading: () {},
  //     );
  //   },
  // );

final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));

    ref.listen(
      authViewModelProvider,
      (_, next) {
        print("Auth State Changed: $next");
        next?.when(
          data: (data) {
            print("logIN DATA:$data");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (_) => false,
            );
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {
            print("isloading From LOGIN");
          },
        );
      },
    );


    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign In.',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(30, 215, 96, 1)
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomeField(
                        hintText: 'Email',
                        controller: emailController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomeField(
                        hintText: 'Password',
                        controller: passwordController,
                        isObscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthGradientButton(
                        buttonText: 'Sign In',
                        onTap: () async {
                          if(formKey.currentState!.validate()){
                            await ref.read(authViewModelProvider.notifier).loginUser(
                              email: emailController.text,
                              password: passwordController.text);
                          }else{
                            showSnackBar(context, 'Missing fields!');
                          }
                          
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: const [
                                TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      color: Color.fromRGBO(30, 215, 96, 1),
                                      fontWeight: FontWeight.bold,
                                    ))
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
    );
  }
}
