import 'package:flutter/material.dart';
import 'package:slip_stream/main_home.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

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
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Widget _authToggleButton(Auth value, String text) {
    final isSelected = _auth == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _auth = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.redAccent : Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.redAccent),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          CustomTextField(controller: _nameController, hintText: "Name"),
          const SizedBox(height: 12),
          CustomTextField(controller: _emailController, hintText: "Email"),
          const SizedBox(height: 12),
          CustomTextField(controller: _passwordController, hintText: "Password"),
          const SizedBox(height: 20),
          CustomButton(
            text: "Sign Up",
            onTap: () {
              if (_signUpFormKey.currentState!.validate()) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'Slip Stream'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _signInFormKey,
      child: Column(
        children: [
          CustomTextField(controller: _emailController, hintText: "Email"),
          const SizedBox(height: 12),
          CustomTextField(controller: _passwordController, hintText: "Password"),
          const SizedBox(height: 20),
          CustomButton(
            text: "Sign In",
            onTap: () {
              if (_signInFormKey.currentState!.validate()) {
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(
                          title: 'Slip Stream',
                          username: 'Max Verstappen',
                          profileImageUrl: 'assets/profile00.jpg',
            ),
          ),
        );
        ;
                      }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Welcome to\nSlip Stream',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  _authToggleButton(Auth.signup, "Sign Up"),
                  const SizedBox(width: 10),
                  _authToggleButton(Auth.signin, "Sign In"),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _auth == Auth.signup
                    ? _buildSignUpForm()
                    : _buildSignInForm(),
              ),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  '🏁 Built for F1 fans, by F1 fans.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
