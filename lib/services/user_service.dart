import 'dart:io';
import 'package:sign_ease/utils/firebase_handler.dart';
import 'package:sign_ease/utils/cloudinary_service.dart';

// SOLID Principle: Single Responsibility - This service handles only user-related operations
class UserService {
  final FirebaseHandler _firebaseHandler;

  UserService({FirebaseHandler? firebaseHandler})
      : _firebaseHandler = firebaseHandler ?? FirebaseHandler();

  // SOLID Principle: Interface Segregation - Separate methods for different responsibilities
  Future<void> signIn(String email, String password) async {
    await _firebaseHandler.signIn(email, password);
  }

  Future<void> signUp(String email, String password) async {
    await _firebaseHandler.signUp(email, password);
  }

  Future<void> signOut() async {
    await _firebaseHandler.signOut();
  }

  Future<void> saveUserData(String email, Map<String, dynamic> userData) async {
    await _firebaseHandler.saveUserData(email, userData);
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    return await _firebaseHandler.getUserData(userId);
  }

  Future<String?> getProfileImageUrl(String userId) async {
    try {
      final userData = await getUserData(userId);
      return userData?['profileImageUrl'] as String?;
    } catch (e) {
      print('Error fetching profile image: $e');
      return null;
    }
  }

  Future<String?> uploadProfileImage(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      final cloudinaryUrl = await CloudinaryService.uploadImageFromBytes(
        await imageFile.readAsBytes(),
        imagePath.split('/').last,
      );
      return cloudinaryUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  Future<void> updateProfileImage(String userId, String imageUrl) async {
    try {
      await _firebaseHandler.firestore
          .collection('profile')
          .doc(userId)
          .update({'profileImageUrl': imageUrl});
    } catch (e) {
      print('Error updating profile image: $e');
    }
  }
}

// SOLID Principle: Dependency Inversion - Abstract interface for user operations
abstract class IUserService {
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signOut();
  Future<void> saveUserData(String email, Map<String, dynamic> userData);
  Future<Map<String, dynamic>?> getUserData(String userId);
  Future<String?> getProfileImageUrl(String userId);
  Future<String?> uploadProfileImage(String imagePath);
  Future<void> updateProfileImage(String userId, String imageUrl);
}
