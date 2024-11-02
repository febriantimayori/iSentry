import 'package:flutter/material.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/presentation/auth/pages/qr_register.dart';
import 'package:isentry/presentation/auth/pages/register.dart';
import 'package:isentry/presentation/auth/widget/text_field.dart';
import 'package:isentry/presentation/auth/widget/button.dart';
import 'package:isentry/presentation/auth/widget/heading.dart';
import 'package:isentry/presentation/home/pages/home_page.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeading(
                title1: 'Welcome back!',
                title2: 'Glad to see you, Again!',
              ),
              CustomTextField(
                hintText: 'Enter your email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Enter your password',
                controller: passwordController,
                obscureText: true,
                suffixIcon: const Icon(
                  LucideIcons.eyeOff,
                  color: Colors.grey, // Tambahkan warna abu-abu pada ikon
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Forgot Password logic here
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600, // Semi-bold menggunakan w600
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              CustomElevatedButton(
                buttonText: 'Login',
                onPressed: () {
                  AppNavigator.push(context, const HomePage());
                },
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Or Login with'),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      AppNavigator.pushAndRemove(
                          context, const QrRegisterPage());
                    },
                    icon: const Icon(Icons.qr_code, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      // google akun
                    },
                    icon: const Icon(Icons.g_mobiledata, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      // GitHub login logic here
                    },
                    icon: const Icon(Icons.code, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      AppNavigator.pushAndRemove(context, const RegisterPage());
                    },
                    child: const Text('Register Now',
                        style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
