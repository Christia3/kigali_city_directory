import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authState => _auth.authStateChanges();

  // ================= SIGN UP =================
  Future<User?> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("USER CREATED: ${cred.user!.email}");

      // send verification email
      await cred.user!.sendEmailVerification();

      print("VERIFICATION EMAIL SENT");

      // create user profile in firestore
      await _db.collection('users').doc(cred.user!.uid).set({
        'email': email,
        'createdAt': DateTime.now(),
      });

      return cred.user;

    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Signup failed";
    } catch (e) {
      throw "Something went wrong";
    }
  }

  // ================= LOGIN =================
  Future<User?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;

    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Login failed";
    } catch (e) {
      throw "Something went wrong";
    }
  }

  // ================= RESEND EMAIL =================
  Future<void> resendVerificationEmail() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
  }
}