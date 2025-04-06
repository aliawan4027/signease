// /////Not USed

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sign_ease/normaluserscreens/normaluser.dart';
// import 'package:sign_ease/signlanguserscreen/signlanguser.dart';
// import 'package:sign_ease/utils/colors_utils.dart';

// class OptionScreen extends StatefulWidget {
//   const OptionScreen({super.key});

//   @override
//   State<OptionScreen> createState() => _OptionScreenState();
// }

// class _OptionScreenState extends State<OptionScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Method to check user registration and navigate accordingly
//   Future<void> handleUserRegistration(String selectedUserType) async {
//     try {
//       // Get the currently logged-in user's email
//       User? currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('No user is logged in.')),
//         );
//         return;
//       }
//       String email = currentUser.email ?? "";

//       // Check if the email is already registered in the 'usertype' collection
//       QuerySnapshot userSnapshot = await _firestore
//           .collection('usertype')
//           .where('email', isEqualTo: email)
//           .get();

//       if (userSnapshot.docs.isNotEmpty) {
//         // User is already registered
//         var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
//         String registeredUserType = userData['type'];

//         if (registeredUserType == selectedUserType) {
//           // Navigate to the appropriate screen based on user type
//           if (selectedUserType == "Normal User") {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const NormalUser()),
//             );
//           } else {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const SignLangUser()),
//             );
//           }
//         } else {
//           // Block navigation and show an error message
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                   'This email is already registered as a $registeredUserType.'),
//             ),
//           );
//         }
//         return;
//       }

//       // If the email is not registered, proceed with registration
//       await registerUser(selectedUserType, email);
//     } catch (e) {
//       // Handle errors and display a message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   // Method to register user in the 'usertype' collection
//   Future<void> registerUser(String userType, String email) async {
//     try {
//       // Get the current date and time for the registration
//       DateTime now = DateTime.now();

//       // Add a new document to the 'usertype' collection
//       await _firestore.collection('usertype').add({
//         'email': email,
//         'registrationDate': now,
//         'type': userType,
//       });

//       // Display success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Successfully registered as $userType')),
//       );

//       // Navigate to the appropriate screen based on user type
//       if (userType == "Normal User") {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const NormalUser()),
//         );
//       } else {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const SignLangUser()),
//         );
//       }
//     } catch (e) {
//       // Handle errors and display a message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 hexStringToColor("ffffff"),
//                 hexStringToColor("ffffff"),
//                 hexStringToColor("ffffff"),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: Column(
//             children: [
//               Expanded(
//                 child: Container(
//                   alignment: Alignment.center,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'Normal User',
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 7, 130, 230),
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Image.asset(
//                         'assets/images/normaluser.jpg',
//                         width: 200,
//                         height: 200,
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () async {
//                           await handleUserRegistration("Normal User");
//                         },
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 10.0, horizontal: 20.0),
//                           backgroundColor:
//                               const Color.fromARGB(255, 7, 130, 230),
//                         ),
//                         child: const Text(
//                           'Click here',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 2,
//                 color: const Color.fromARGB(255, 7, 130, 230),
//               ),
//               Expanded(
//                 child: Container(
//                   alignment: Alignment.center,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'Sign Language User',
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 7, 130, 230),
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Image.asset(
//                         'assets/images/signlanguser.png',
//                         width: 150,
//                         height: 150,
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () async {
//                           await handleUserRegistration("Sign Language User");
//                         },
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 10.0, horizontal: 20.0),
//                           backgroundColor:
//                               const Color.fromARGB(255, 7, 130, 230),
//                         ),
//                         child: const Text(
//                           'Click here',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// /////Not USed