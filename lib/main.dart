import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/listing_provider.dart';
import 'services/auth_service.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ListingProvider()..listenToListings(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authState,
      builder: (context, snapshot) {

        // NOT LOGGED IN
        if (!snapshot.hasData) {
          return LoginScreen();
        }

        final user = _auth.currentUser!;

        // EMAIL NOT VERIFIED
        if (!user.emailVerified) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Please verify your email first",
                    style: TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      await user.reload();
                      setState(() {});
                    },
                    child: const Text("I have verified. Refresh"),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () async {
                      await _auth.resendVerificationEmail();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Verification email sent again"),
                        ),
                      );
                    },
                    child: const Text("Resend email"),
                  ),
                ],
              ),
            ),
          );
        }

        // VERIFIED → ENTER APP
        return const HomeScreen();
      },
    );
  }
}