import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHandler {
  // Real Firebase for web
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    DocumentSnapshot doc =
        await firestore.collection('users').doc(userId).get();
    return doc.data() as Map<String, dynamic>?;
  }

  Future<void> saveUserData(
      String userId, Map<String, dynamic> userData) async {
    await firestore.collection('users').doc(userId).set(userData);
  }
}
