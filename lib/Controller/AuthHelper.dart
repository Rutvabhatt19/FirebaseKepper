// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class GoogleHelper {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<bool> isEmailRegistered(String email) async {
//     try {
//       List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
//       return signInMethods.isNotEmpty;
//     } catch (e) {
//       print("Error checking if email is registered: $e");
//       return false;
//     }
//   }
//
//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return null;
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       bool isRegistered = await isEmailRegistered(googleUser.email);
//       if (!isRegistered) {
//         Fluttertoast.showToast(msg: "You don't have an account. Please create one.");
//         await _googleSignIn.signOut();
//         return null;
//       }
//
//       UserCredential userCredential = await _auth.signInWithCredential(credential);
//       return userCredential.user;
//     } catch (e) {
//       print("Error signing in with Google: $e");
//       return null;
//     }
//   }
//
//   Future<User?> signInWithEmail(String email, String password) async {
//     try {
//       bool isRegistered = await isEmailRegistered(email);
//       if (!isRegistered) {
//         Fluttertoast.showToast(msg: "You don't have an account. Please create one.");
//         return null;
//       }
//
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } catch (e) {
//       print("Error signing in with Email/Password: $e");
//       Fluttertoast.showToast(msg: "Login failed. Please check your credentials.");
//       return null;
//     }
//   }
//
//   Future<User?> createAccountWithEmail(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       await _addUserToFirestore(userCredential.user);
//
//       return userCredential.user;
//     } catch (e) {
//       print("Error creating account with Email/Password: $e");
//       Fluttertoast.showToast(msg: "Account creation failed.");
//       return null;
//     }
//   }
//
//   // Private method to add user details to Firestore
//   Future<void> _addUserToFirestore(User? user) async {
//     if (user != null) {
//       try {
//         await _firestore.collection('users').doc(user.uid).set({
//           'uid': user.uid,
//           'email': user.email,
//           'displayName': user.displayName ?? '', // For Google users
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//         print("User added to Firestore");
//       } catch (e) {
//         print("Error adding user to Firestore: $e");
//       }
//     }
//   }
//
//   Future<void> signOut() async {
//     await _auth.signOut();
//     await _googleSignIn.signOut();
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  AuthHelper._();

  static final AuthHelper authHelper = AuthHelper._();

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> anonymousSignIn() async {
    UserCredential userCredential = await firebaseAuth.signInAnonymously();
    User? user = userCredential.user;
    return user;
  }

  Future<User?> signUp(
      {required String email, required String password}) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    return user;
  }

  Future<User?> signIn(
      {required String email, required String password}) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    return user;
  }

  Future<void> signOutUser() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google sign-in error: $e");
      return null;
    }
  }
}
