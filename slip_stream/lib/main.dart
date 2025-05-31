import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import your auth_screen.dart file here (adjust the path as needed)
import 'auth/auth_screen.dart';

// If you have a separate sign in screen, import that instead or alongside
// import 'auth/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set initial route to AuthScreen or home directly
      home: const AuthScreen(),
      routes: {
        AuthScreen.routeName: (context) => const AuthScreen(),
        // Add other routes here if you want
      },
    );
  }
}
