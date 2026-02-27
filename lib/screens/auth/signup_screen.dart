import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthService _auth = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// EMAIL FIELD
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// PASSWORD FIELD
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            /// SIGNUP BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                try {
                  await _auth.signUp(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Account created! Verification email sent. Check spam if not in inbox.",
                      ),
                    ),
                  );

                  Navigator.pop(context);

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: const Text("Sign Up"),
            ),

            const SizedBox(height: 15),

            /// RESEND EMAIL BUTTON
            TextButton(
              onPressed: () async {
                await _auth.resendVerificationEmail();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Verification email sent again")),
                );
              },
              child: const Text("Resend verification email"),
            ),

            const SizedBox(height: 10),

            

            /// BACK TO LOGIN
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Already have account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}