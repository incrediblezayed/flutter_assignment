import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service class for authentication.
class AuthService {
  AuthService._();

  /// Singleton instance of [FirebaseAuth].
  static final instance = FirebaseAuth.instance;

  /// Returns the stream of [User] objects.
  /// Returns null if the user is not logged in.
  static final authStateChanges = instance.authStateChanges();

  /// Returns the current user.
  static final currentUser = instance.currentUser;

  /// Logs in the user using Google Sign In.
  static Future<String?> login() async {
    final googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/calendar',
      ],
    );
    final googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await instance.signInWithCredential(credential);

      return googleSignInAuthentication.accessToken!;
    }
    return null;
  }

  /// Logs out the user.
  static Future<void> logout() async {
    await instance.signOut();
  }
}
