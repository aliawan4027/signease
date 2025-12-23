import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sign_ease/screens/profile.dart';
import 'package:sign_ease/screens/report.dart';
import 'package:sign_ease/signlanguserscreen/gameSLU.dart';
import 'package:sign_ease/signlanguserscreen/model_prediction.dart';
import 'package:sign_ease/signlanguserscreen/signlanguserchathead.dart';
import 'package:sign_ease/signlanguserscreen/startchatSL.dart';
import 'package:sign_ease/utils/colors_utils.dart';
import 'package:sign_ease/utils/firebase_handler.dart';
import 'package:flutter/services.dart';

class SignLangUser extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userId;

  const SignLangUser(
      {super.key,
      required this.userName,
      required this.userEmail,
      required this.userId});

  @override
  State<SignLangUser> createState() => _SignLangUserState();
}

class _SignLangUserState extends State<SignLangUser> {
  int _selectedIndex = 1;
  final FirebaseHandler _firebaseHandler = FirebaseHandler();
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = widget.userId;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Map<String, dynamic>> _getUserDetails(String userId) async {
    try {
      // First try to get profile image from profile collection
      DocumentSnapshot profileDoc = await _firebaseHandler.firestore
          .collection('profile')
          .doc(userId)
          .get();

      // Fallback to users collection if profile doesn't exist
      DocumentSnapshot userDoc = await _firebaseHandler.firestore
          .collection('users')
          .doc(userId)
          .get();

      Map<String, dynamic> result = {};

      if (profileDoc.exists && profileDoc.data() != null) {
        final profileData = profileDoc.data() as Map<String, dynamic>;
        print('SL Profile data found: $profileData'); // Debug line
        result['username'] = profileData['name'] ?? 'Unknown User';
        result['email'] = profileData['email'] ?? 'Unknown Email';
        result['profileImageUrl'] = profileData['profileImageUrl'] ?? '';
      } else if (userDoc.exists && userDoc.data() != null) {
        final userData = userDoc.data() as Map<String, dynamic>;
        print('SL User data found: $userData'); // Debug line
        result = userData;
      } else {
        print(
            'No SL profile or user data found for userId: $userId'); // Debug line
        result = {'username': 'Unknown User', 'email': 'Unknown Email'};
      }

      return result;
    } catch (e) {
      print('Error fetching user details: $e');
      return {'username': 'Unknown User', 'email': 'Unknown Email'};
    }
  }

  Future<void> _deleteChat(String chatId) async {
    try {
      // Delete all messages in chat
      final messagesRef = _firebaseHandler.firestore
          .collection('universalMessages')
          .doc(chatId)
          .collection('messages');

      final messagesSnapshot = await messagesRef.get();
      for (var messageDoc in messagesSnapshot.docs) {
        await messageDoc.reference.delete();
      }

      // Delete the chat room itself
      await _firebaseHandler.firestore
          .collection('universalChats')
          .doc(chatId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat and messages deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete chat: $e')),
      );
    }
  }

  Future<bool> _onWillPop() async {
    // Show the confirmation dialog
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // No, stay in app
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop(); // Exit the app completely
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      const Profile(),
      StreamBuilder<QuerySnapshot>(
        stream: _firebaseHandler.firestore
            .collection('universalChats')
            .where('participants', arrayContains: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data?.docs ?? [];
          if (chats.isEmpty) {
            return const Center(
              child: Text('No chats yet. Start a new chat!'),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final chatData = chatDoc.data() as Map<String, dynamic>;
              final List<dynamic> participants = chatData['participants'];
              final otherUserId =
                  participants.firstWhere((id) => id != currentUserId);

              return FutureBuilder<Map<String, dynamic>>(
                future: _getUserDetails(otherUserId),
                builder: (context, userDetailsSnapshot) {
                  if (userDetailsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/demo.jpg'),
                      ),
                      title: Text('Loading...'),
                    );
                  }

                  final userDetails = userDetailsSnapshot.data!;
                  final userName = userDetails['username'] ?? 'Unknown User';
                  final userEmail = userDetails['email'] ?? 'Unknown Email';
                  final profileImageUrl = userDetails['profileImageUrl'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignLangUserChatHead(
                            userId: otherUserId,
                            userEmail: userEmail,
                            userName: userName,
                            userEmails: [userEmail],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl) as ImageProvider
                              : const AssetImage('assets/demo.jpg'),
                        ),
                        title: Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 7, 130, 230),
                          ),
                        ),
                        subtitle: Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 7, 130, 230),
                          ),
                        ),
                        tileColor: const Color.fromARGB(255, 220, 230, 240),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Chat'),
                                  content: const Text(
                                      'Are you sure you want to delete this chat?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmDelete == true) {
                              _deleteChat(chatDoc.id);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      const GameSL(),
      const ModelPrediction(),
      const Report(),
    ];

    return WillPopScope(
      onWillPop: _onWillPop, // Add this to intercept back button
      child: Scaffold(
        appBar: _selectedIndex == 1
            ? AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: hexStringToColor("2986cc"),
                title: const Text('Chats'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StartChatSL(),
                        ),
                      );
                    },
                    tooltip: 'Start New Chat',
                  ),
                ],
              )
            : null,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexStringToColor("ffffff"),
                hexStringToColor("ffffff"),
                hexStringToColor("ffffff"),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _widgetOptions[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports),
              label: 'Game',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pan_tool),
              label: 'Signs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Report',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
