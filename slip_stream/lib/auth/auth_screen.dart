import 'package:flutter/material.dart';
import 'package:slip_stream/main_home.dart';
import '../widgets/custom_text_field.dart';  // adjust path as needed
import '../widgets/custom_button.dart';
import '../constants/global_variables.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to F1 Fan App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC0000), // F1 Red
                ),
              ),
              const SizedBox(height: 12),

              ListTile(
                tileColor: _auth == Auth.signup ? Color(0xFFF2F2F2) : Colors.black,
                title: Text(
                  'Create Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _auth == Auth.signup ? Colors.black : Colors.white,
                  ),
                ),
                leading: Radio<Auth>(
                  activeColor: Color(0xFFDC0000),
                  fillColor: MaterialStateProperty.all(Color(0xFFDC0000)),
                  value: Auth.signup,
                  groupValue: _auth,
                  onChanged: (Auth? val) {
                    setState(() {
                      _auth = val!;
                    });
                  },
                ),
              ),

              if (_auth == Auth.signup)
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Color(0xFFF2F2F2),
                  child: Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _nameController,
                          hintText: "Name",
                          // keep default colors inside CustomTextField
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _emailController,
                          hintText: "Email",
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: "Password",
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: "Sign Up!",
                          // If your button supports color param:
                          // color: Color(0xFFDC0000),
                          onTap: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MyHomePage(title: 'F1 Fan App'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              ListTile(
                tileColor: _auth == Auth.signin ? Color(0xFFF2F2F2) : Colors.black,
                title: Text(
                  'Sign in to Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _auth == Auth.signin ? Colors.black : Colors.white,
                  ),
                ),
                leading: Radio<Auth>(
                  activeColor: Color(0xFFDC0000),
                  fillColor: MaterialStateProperty.all(Color(0xFFDC0000)),
                  value: Auth.signin,
                  groupValue: _auth,
                  onChanged: (Auth? val) {
                    setState(() {
                      _auth = val!;
                    });
                  },
                ),
              ),

              if (_auth == Auth.signin)
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Color(0xFFF2F2F2),
                  child: Form(
                    key: _signInFormKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          hintText: "Email",
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: "Password",
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: "Sign In!",
                          // color: Color(0xFFDC0000),
                          onTap: () {
                            if (_signInFormKey.currentState!.validate()) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MyHomePage(title: 'F1 Fan App'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
