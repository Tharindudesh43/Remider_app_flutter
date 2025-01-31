import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';

class FirebaseAuthService {
  static Future<String> signIn(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("found");
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        return "invalid-credential";
      } else {
        return "error";
      }
    }
  }

  static Future<String?> signup({
    required String email,
    required String password,
    required String name,
    required String mobilenumber,
  }) async {
    try {
      // Attempt to create a new user with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //Listen for auth state changes to ensure the user is created
      // FirebaseAuth.instance.authStateChanges().listen((User? user) {
      //   if (user != null) {
      // Add user details to Firestore or another service
      FirebaseService.addSignUser(
        email: email,
        name: name,
        mobilenumber: mobilenumber,
      );
      // }
      //  });

      return "User Added";
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthException errors
      if (e.code == 'email-already-in-use') {
        print('Email is already in use.');
        return "email-already-in-use";
      } else {
        // Handle other FirebaseAuthException errors
        print('FirebaseAuthException: $e');
        return e.code.toString();
      }
    } catch (e) {
      // Handle any other exceptions
      print("Error: $e");
      return e.toString();
    }
  }

  static Future<String> signInWithGoogle() async {
    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return "user canceled";
      }

      // Obtain the Google sign-in authentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userCredential.user?.email.toString())
          .get();
      if (result.docs.isEmpty) {
        print("EEEEEEEEEEEEEEe");
        FirebaseService.addgoogleesigninuser(
            email: userCredential.user?.email.toString(),
            name: userCredential.user?.displayName.toString());
      }

      print("Signed in: ${userCredential.user?.displayName}");
      print("Email: ${userCredential.user?.email}");
      // print("Profile Picture: ${userCredential.user?.photoURL}");

      // Return the signed-in user
      return "Google User Added";
    } catch (e) {
      print('Google sign-in failed: $e');
      return "google sign in failed";
    }
  }
}
