import 'package:flutter/material.dart';
import 'package:sign_ease/normaluserscreens/normaluser.dart';
import 'package:sign_ease/signlanguserscreen/signlanguser.dart';
import 'package:sign_ease/utils/colors_utils.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose User Type"),
        backgroundColor: hexStringToColor("2E7D32"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("ffffff"),
              hexStringToColor("f0f0f0"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Select Your User Type",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NormalUser()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Normal User",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignLangUser(
                        userName: '',
                        userEmail: '',
                        userId: '',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Sign Language User",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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