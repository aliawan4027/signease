// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sign_ease/normaluserscreens/normaluserchathead.dart';
// import 'package:sign_ease/signlanguserscreen/signlanguserchathead.dart';

// class CommonChatHead extends StatefulWidget {
//   final String userId;
//   final String otherUserId;
//   final String otherUserEmail;
//   final String otherUserName;
//   final String otherUserType;

//   const CommonChatHead({
//     Key? key,
//     required this.userId,
//     required this.otherUserId,
//     required this.otherUserEmail,
//     required this.otherUserName,
//     required this.otherUserType,
//   }) : super(key: key);

//   @override
//   State<CommonChatHead> createState() => _CommonChatHeadState();
// }

// class _CommonChatHeadState extends State<CommonChatHead> {
//   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
//   String? currentUserType;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUserType();
//   }

//   Future<void> _getCurrentUserType() async {
//     try {
//       // Fetch the current user's type directly from the `users` collection
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUserId)
//           .get();

//       if (userDoc.exists) {
//         setState(() {
//           currentUserType = userDoc['userType'] ?? '';
//         });
//       } else {
//         print("User document not found.");
//       }
//     } catch (e) {
//       print("Error fetching user type: $e");
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (currentUserType == null) {
//       return const Scaffold(
//         body: Center(child: Text('User type not found.')),
//       );
//     }

//     // Render Normal or Sign Language Chat Head based on user type
//     if (currentUserType == 'signLangUser') {
//       return SignLanguageUserChatScreen(
//         userId: widget.otherUserId,
//         userEmail: widget.otherUserEmail,
//         userName: widget.otherUserName,
//         userEmail: [widget.otherUserEmail], chatRoomId: '', receiverId: '',
//       );
//     } else {
//       return NormalUserChatHead(
//         userId: widget.otherUserId,
//         userEmail: widget.otherUserEmail,
//         userName: widget.otherUserName,
//         userEmails: [widget.otherUserEmail],
//       );
//     }
//   }
// }
